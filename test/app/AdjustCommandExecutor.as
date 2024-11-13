package {
    import flash.utils.Dictionary;
    import com.adjust.sdk.Adjust;
    import com.adjust.sdk.AdjustConfig;
    import com.adjust.sdk.AdjustEvent;
    import com.adjust.sdk.AdjustTestOptions;
    import com.adjust.sdk.AdjustEventSuccess;
    import com.adjust.sdk.AdjustEventFailure;
    import com.adjust.sdk.AdjustSessionSuccess;
    import com.adjust.sdk.AdjustSessionFailure;
    import com.adjust.sdk.AdjustAttribution;
    import com.adjust.sdk.AdjustAdRevenue;
    import com.adjust.sdk.AdjustDeeplink;
    import com.adjust.sdk.AdjustThirdPartySharing;
    import com.adjust.sdk.AdjustAppStorePurchase;
    import com.adjust.sdk.AdjustPlayStorePurchase;
    import com.adjust.sdk.AdjustPurchaseVerificationResult;
    import com.adjust.sdk.AdjustAppStoreSubscription;
    import com.adjust.sdk.AdjustPlayStoreSubscription;
    import com.adjust.sdk.AdjustEnvironment;
    import com.adjust.sdk.AdjustLogLevel;
    import com.adjust.test.AdjustTest;

    /* 
     * A note on scheduling:
     *
     * Callbacks sent from Java -> Javascript through PluginResult are by nature not ordered.
     *  scheduleCommand(command) tries to receive commands and schedule them in an array (this.savedCommand)
     *  that would be executed based on what `this.nextToSendCounter` specifies.
     * 
     * Sorting mechanism goes as follows
     * - When receiving a new command...
     *   * if the new command is in order, send it immediately.
     *   * If the new command is not in order
     *     * Store it in a list
     *     * Check the list if it contains the next command to send
     * - After sending a command...
     *     * Check the list if it contains the next command to send
     * 
     * So this system is rechecking the list for items to send on two events:
     * - When a new not-in-order object is added.
     * - After a successful send
     */

    public class AdjustCommandExecutor {
        // Made as static to be accessible from delegates
        public static var urlOverwrite:String;
        public static var extraPath:String;
        private var savedEvents:Dictionary;
        private var savedConfigs:Dictionary;
        private var savedCommands:Array;
        private var nextToSendCounter:int;

        public function AdjustCommandExecutor(urlOverwrite:String) {
            AdjustCommandExecutor.urlOverwrite = urlOverwrite;
            AdjustCommandExecutor.extraPath = null;
            this.savedEvents = new Dictionary();
            this.savedConfigs = new Dictionary();
            this.savedCommands = new Array();
            this.nextToSendCounter = 0;
        }

        // First point of entry for scheduling commands. Takes a "AdjustCommand {command}" parameter
        public function scheduleCommand(command:AdjustCommand):void {
            // If the command is in order, send in immediately
            if (command.order === this.nextToSendCounter) {
                this.executeCommand(command, -1);
                return;
            }

            // Not in order, schedule it
            this.savedCommands.push(command);

            // Recheck list
            this.checkList();
        }

        // Check the list of commands to see which one is in order
        private function checkList():void {
            for (var i:int = 0; i < this.savedCommands.length; i++) {
                var command:AdjustCommand = this.savedCommands[i];
                if (command.order === this.nextToSendCounter) {
                    this.executeCommand(command, i);
                    return;
                }
            }
        }

        // Execute the command. This will always be invoked either from:
        //  - checkList() after scheduling a command
        //  - scheduleCommand() only if the package was in order
        //
        // (AdjustCommand {command}) : The command to be executed
        // (Number {idx})            : index of the command in the schedule list. -1 if it was sent directly
        public function executeCommand(command:AdjustCommand, idx:Number):void {
            switch (command.functionName) {
                case "testOptions" : this.testOptions(command.params); break;
                case "config" : this.config(command.params); break;
                case "start" : this.start(command.params); break;
                case "event" : this.eventFunc(command.params); break;
                case "trackEvent" : this.trackEvent(command.params); break;
                case "resume" : this.resume(command.params); break;
                case "pause" : this.pause(command.params); break;
                case "setEnabled" : this.setEnabled(command.params); break;
                case "setOfflineMode" : this.setOfflineMode(command.params); break;
                case "addGlobalCallbackParameter" : this.addGlobalCallbackParameter(command.params); break;
                case "removeGlobalCallbackParameter" : this.removeGlobalCallbackParameter(command.params); break;
                case "removeGlobalCallbackParameters" : this.removeGlobalCallbackParameters(command.params); break;
                case "addGlobalPartnerParameter" : this.addGlobalPartnerParameter(command.params); break;
                case "removeGlobalPartnerParameter" : this.removeGlobalPartnerParameter(command.params); break;
                case "removeGlobalPartnerParameters" : this.removeGlobalPartnerParameters(command.params); break;
                case "setPushToken" : this.setPushToken(command.params); break;
                case "openDeeplink" : this.openDeeplink(command.params); break;
                case "gdprForgetMe" : this.gdprForgetMe(command.params); break;
                case "trackAdRevenue" : this.trackAdRevenue(command.params); break;
                case "attributionGetter" : this.attributionGetter(command.params); break;
                case "measurementConsent" : this.trackMeasurementConsent(command.params); break;
                case "thirdPartySharing" : this.trackThirdPartySharing(command.params); break;
                case "getLastDeeplink" : this.getLastDeeplink(command.params); break;
                case "processDeeplink" : this.processDeeplink(command.params); break;
                case "verifyPurchase" : this.verifyPurchase(command.params); break;
                case "trackSubscription" : this.trackSubscription(command.params); break;
                case "verifyTrack" : this.verifyTrack(command.params); break;
            }

            this.nextToSendCounter++;

            // If idx != -1, it means it was not sent directly. Delete its instance from the scheduling array
            if (idx != -1) {
                this.savedCommands.splice(idx, 1);
            }

            // Recheck the list
            this.checkList();
        }

        private function testOptions(params:Object):void {
            var testOptions:AdjustTestOptions = new AdjustTestOptions();
            testOptions.testUrlOverwrite = AdjustCommandExecutor.urlOverwrite;

            if (params["basePath"] != null) {
                AdjustCommandExecutor.extraPath = getFirstParameterValue(params, "basePath");
            }
            if (params["timerInterval"] != null) {
                testOptions.timerIntervalInMilliseconds = getFirstParameterValue(params, "timerInterval");
            }
            if (params["timerStart"] != null) {
                testOptions.timerStartInMilliseconds = getFirstParameterValue(params, "timerStart");
            }
            if (params["sessionInterval"] != null) {
                testOptions.sessionIntervalInMilliseconds = getFirstParameterValue(params, "sessionInterval");
            }
            if (params["subsessionInterval"] != null) {
                testOptions.subsessionIntervalInMilliseconds = getFirstParameterValue(params, "subsessionInterval");
            }
            //if (params["tryInstallReferrer"] != null) {
            //    testOptions.tryInstallReferrer = getFirstParameterValue(params, "tryInstallReferrer") == "true";
            //}
            if (params["attStatus"] != null) {
                testOptions.attStatus = getFirstParameterValue(params, "attStatus");
            }
            if (params["idfa"] != null) {
                testOptions.idfa = getFirstParameterValue(params, "idfa");
            }
            if (params["noBackoffWait"] != null) {
                testOptions.noBackoffWait = getFirstParameterValue(params, "noBackoffWait") == "true";
            }
            if (params["adServicesFrameworkEnabled"] != null) {
                testOptions.adServicesFrameworkEnabled = getFirstParameterValue(params, "adServicesFrameworkEnabled") == "true";
            }
            if (params["doNotIgnoreSystemLifecycleBootstrap"] != null) {
                var doNotIgnoreSystemLifecycleBootstrap:Boolean = getFirstParameterValue(params, "doNotIgnoreSystemLifecycleBootstrap") == "true";
                if (doNotIgnoreSystemLifecycleBootstrap) {
                    testOptions.ignoreSystemLifecycleBootstrap = false;
                }
            }
            var useTestConnectionOptions:Boolean = false;
            if (params["teardown"] != null) {
                var teardownOptions:Array = getValueFromKey(params, "teardown");
                for (var i:int = 0; i < teardownOptions.length; i++) {
                    var option:String = teardownOptions[i];

                    if ("resetSdk" === option) {
                        testOptions.teardown = true;
                        testOptions.extraPath = AdjustCommandExecutor.extraPath;
                        useTestConnectionOptions = true;
                        //testOptions.tryInstallReferrer = false;
                    }
                    if ("deleteState" === option) {
                        testOptions.deleteState = true;
                    }
                    if ("resetTest" === option) {
                        this.savedEvents = new Dictionary();
                        this.savedConfigs = new Dictionary();
                        testOptions.timerIntervalInMilliseconds = "-1";
                        testOptions.timerStartInMilliseconds = "-1";
                        testOptions.sessionIntervalInMilliseconds = "-1";
                        testOptions.subsessionIntervalInMilliseconds = "-1";
                    }
                    if ("sdk" === option) {
                        testOptions.teardown = true;
                        testOptions.extraPath = null;
                    }
                    if ("test" === option) {
                        this.savedEvents = null;
                        this.savedConfigs = null;
                        testOptions.timerIntervalInMilliseconds = "-1";
                        testOptions.timerStartInMilliseconds = "-1";
                        testOptions.sessionIntervalInMilliseconds = "-1";
                        testOptions.subsessionIntervalInMilliseconds = "-1";
                    }
                }
            }

            Adjust.setTestOptions(testOptions);
            if (useTestConnectionOptions == true) {
                AdjustTest.setTestConnectionOptions();
            }
            Adjust.teardown();
        }

        private function config(params:Object):void {
            var configNumber:int = 0
                if (params["configName"] != null) {
                    var configName:String = getFirstParameterValue(params, "configName");
                    configNumber = parseInt(configName.substr(configName.length - 1));
                }
            var adjustConfig:AdjustConfig;
            if (this.savedConfigs[configNumber] != null) {
                adjustConfig = this.savedConfigs[configNumber];
            } else {
                var environment:String = getFirstParameterValue(params, "environment");
                var appToken:String = getFirstParameterValue(params, "appToken");
                adjustConfig = new AdjustConfig(appToken, environment);
                adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);
                this.savedConfigs[configNumber] = adjustConfig;
            }
            if (params["logLevel"] != null) {
                var logLevel:String = getFirstParameterValue(params, "logLevel");
                adjustConfig.setLogLevel(logLevel);
            }
            if (params["defaultTracker"] != null) {
                var defaultTracker:String = getFirstParameterValue(params, "defaultTracker");
                adjustConfig.setDefaultTracker(defaultTracker);
            }
            if (params["externalDeviceId"] != null) {
                var externalDeviceId:String = getFirstParameterValue(params, "externalDeviceId");
                adjustConfig.setExternalDeviceId(externalDeviceId);
            }
            if (params["sendInBackground"] != null) {
                var sendInBackgroundS:String = getFirstParameterValue(params, "sendInBackground");
                var sendInBackground:Boolean = (sendInBackgroundS === "true");
                if (sendInBackground) {
                    adjustConfig.enableSendingInBackground();
                }
            }
            if (params["coppaCompliant"] != null) {
                var coppaCompliantS:String = getFirstParameterValue(params, "coppaCompliant");
                var coppaCompliant:Boolean = (coppaCompliantS === "true");
                if (coppaCompliant) {
                    adjustConfig.enableCoppaCompliance();
                }
            }
            if (params["needsCost"] != null) {
                var needsCostS:String = getFirstParameterValue(params, "needsCost");
                var needsCost:Boolean = (needsCostS === "true");
                if (needsCost) {
                    adjustConfig.enableCostDataInAttribution();
                }
            }
            if (params["eventDeduplicationIdsMaxSize"] != null) {
                var eventDeduplicationIdsMaxSizeS:String = getFirstParameterValue(params, "eventDeduplicationIdsMaxSize");
                var eventDeduplicationIdsMaxSize:int = parseInt(eventDeduplicationIdsMaxSizeS);
                adjustConfig.setEventDeduplicationIdsMaxSize(eventDeduplicationIdsMaxSize);
            }
            if (params["allowIdfaReading"] != null) {
                var allowIdfaReadingS:String = getFirstParameterValue(params, "allowIdfaReading");
                var allowIdfaReading:Boolean = (allowIdfaReadingS === "true");
                if (allowIdfaReading == false) {
                    adjustConfig.disableIdfaReading();
                }
            }
            if (params["allowAdServicesInfoReading"] != null) {
                var allowAdServicesInfoReadingS:String = getFirstParameterValue(params, "allowAdServicesInfoReading");
                var allowAdServicesInfoReading:Boolean = (allowAdServicesInfoReadingS === "true");
                if (allowAdServicesInfoReading == false) {
                    adjustConfig.disableAdServices();
                }
            }
            if (params["allowSkAdNetworkHandling"] != null) {
                var allowSkAdNetworkHandlingS:String = getFirstParameterValue(params, "allowSkAdNetworkHandling");
                var allowSkAdNetworkHandling:Boolean = (allowSkAdNetworkHandlingS === "true");
                if (allowSkAdNetworkHandling == false) {
                    adjustConfig.disableSkanAttribution();
                }
            }
            if (params["attConsentWaitingSeconds"] != null) {
                var attConsentWaitingSecondsS:String = getFirstParameterValue(params, "attConsentWaitingSeconds");
                var attConsentWaitingSeconds:int = parseInt(attConsentWaitingSecondsS);
                adjustConfig.setAttConsentWaitingInterval(attConsentWaitingSeconds);
            }
            if (params["playStoreKids"] != null) {
                var playStoreKidsS:String = getFirstParameterValue(params, "playStoreKids");
                var playStoreKids:Boolean = (playStoreKidsS === "true");
                if (playStoreKids) {
                    adjustConfig.enablePlayStoreKidsCompliance();
                }
            }
            if (params["attributionCallbackSendAll"] != null) {
                adjustConfig.setAttributionCallback(function (attribution:AdjustAttribution):void {
                    AdjustTest.addInfoToSend("tracker_token", attribution.getTrackerToken());
                    AdjustTest.addInfoToSend("tracker_name", attribution.getTrackerName());
                    AdjustTest.addInfoToSend("network", attribution.getNetwork());
                    AdjustTest.addInfoToSend("campaign", attribution.getCampaign());
                    AdjustTest.addInfoToSend("adgroup", attribution.getAdGroup());
                    AdjustTest.addInfoToSend("creative", attribution.getCreative());
                    AdjustTest.addInfoToSend("click_label", attribution.getClickLabel());
                    AdjustTest.addInfoToSend("cost_type", attribution.getCostType());
                    AdjustTest.addInfoToSend(
                        "cost_amount",
                        isNaN(attribution.getCostAmount()) ? null : attribution.getCostAmount().toString());
                    AdjustTest.addInfoToSend("cost_currency", attribution.getCostCurrency());
                    AdjustTest.addInfoToSend("fb_install_referrer", attribution.getFbInstallReferrer());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["sessionCallbackSendSuccess"] != null) {
                adjustConfig.setSessionSuccessCallback(function (sessionSuccess:AdjustSessionSuccess):void {
                    AdjustTest.addInfoToSend("message", sessionSuccess.getMessage());
                    AdjustTest.addInfoToSend("timestamp", sessionSuccess.getTimestamp());
                    AdjustTest.addInfoToSend("adid", sessionSuccess.getAdid());
                    AdjustTest.addInfoToSend("jsonResponse", sessionSuccess.getJsonResponse());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["sessionCallbackSendFailure"] != null) {
                adjustConfig.setSessionFailureCallback(function (sessionFaulure:AdjustSessionFailure):void {
                    AdjustTest.addInfoToSend("message", sessionFaulure.getMessage());
                    AdjustTest.addInfoToSend("timestamp", sessionFaulure.getTimestamp());
                    AdjustTest.addInfoToSend("adid", sessionFaulure.getAdid());
                    AdjustTest.addInfoToSend("willRetry", sessionFaulure.getWillRetry().toString());
                    AdjustTest.addInfoToSend("jsonResponse", sessionFaulure.getJsonResponse());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["eventCallbackSendSuccess"] != null) {
                adjustConfig.setEventSuccessCallback(function (eventSuccess:AdjustEventSuccess):void {
                    AdjustTest.addInfoToSend("message", eventSuccess.getMessage());
                    AdjustTest.addInfoToSend("timestamp", eventSuccess.getTimestamp());
                    AdjustTest.addInfoToSend("adid", eventSuccess.getAdid());
                    AdjustTest.addInfoToSend("eventToken", eventSuccess.getEventToken());
                    AdjustTest.addInfoToSend("callbackId", eventSuccess.getCallbackId());
                    AdjustTest.addInfoToSend("jsonResponse", eventSuccess.getJsonResponse());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["eventCallbackSendFailure"] != null) {
                adjustConfig.setEventFailureCallback(function (eventFailure:AdjustEventFailure):void {
                    AdjustTest.addInfoToSend("message", eventFailure.getMessage());
                    AdjustTest.addInfoToSend("timestamp", eventFailure.getTimestamp());
                    AdjustTest.addInfoToSend("adid", eventFailure.getAdid());
                    AdjustTest.addInfoToSend("eventToken", eventFailure.getEventToken());
                    AdjustTest.addInfoToSend("callbackId", eventFailure.getCallbackId());
                    AdjustTest.addInfoToSend("willRetry", eventFailure.getWillRetry().toString());
                    AdjustTest.addInfoToSend("jsonResponse", eventFailure.getJsonResponse());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["deferredDeeplinkCallback"] != null) {
                var shouldLaunchDeeplinkS:String = getFirstParameterValue(params, "deferredDeeplinkCallback");
                var shouldLaunchDeeplink:Boolean = (shouldLaunchDeeplinkS === "true");
                if (shouldLaunchDeeplink == false) {
                    adjustConfig.disableDeferredDeeplinkOpening();
                }
                adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
                    AdjustTest.addInfoToSend("deeplink", deeplink);
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
            if (params["skanCallback"] != null) {
                adjustConfig.setSkanUpdatedCallback(function (skanUpdatedData:Dictionary):void {
                    AdjustTest.addInfoToSend("conversion_value", skanUpdatedData["conversionValue"].toString());
                    AdjustTest.addInfoToSend("coarse_value", skanUpdatedData["coarseValue"]);
                    AdjustTest.addInfoToSend("lock_window", skanUpdatedData["lockWindow"].toString());
                    AdjustTest.addInfoToSend("error", skanUpdatedData["error"]);
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
        }

        private function start(params:Object):void {
            this.config(params);
            var configNumber:int = 0
                if (params["configName"] != null) {
                    var configName:String = getFirstParameterValue(params, "configName");
                    configNumber = parseInt(configName.substr(configName.length - 1));
                }

            var adjustConfig:AdjustConfig = this.savedConfigs[configNumber];
            Adjust.initSdk(adjustConfig);
            delete this.savedConfigs[0];
        }

        private function eventFunc(params:Object):void {
            var eventNumber:int = 0
            if (params["eventName"] != null) {
                var eventName:String = getFirstParameterValue(params, "eventName");
                eventNumber = parseInt(eventName.substr(eventName.length - 1));
            }

            var adjustEvent:AdjustEvent;
            if (this.savedEvents[eventNumber] != null) {
                adjustEvent = this.savedEvents[eventNumber];
            } else {
                var eventToken:String = getFirstParameterValue(params, "eventToken");
                adjustEvent = new AdjustEvent(eventToken);
                this.savedEvents[eventNumber] = adjustEvent;

            }
            if (params["revenue"] != null) {
                var revenueParams:Array = getValueFromKey(params, "revenue");
                var currency:String = revenueParams[0];
                var revenue:Number = Number(revenueParams[1]);
                adjustEvent.setRevenue(revenue, currency);
            }
            if (params["callbackParams"] != null) {
                var callbackParams:Array = getValueFromKey(params, "callbackParams");
                for (var i:int = 0; i < callbackParams.length; i = i+2) {
                    var key:String = callbackParams[i];
                    var value:String = callbackParams[i+1];
                    adjustEvent.addCallbackParameter(key, value);
                }
            }
            if (params["partnerParams"] != null) {
                var partnerParams:Array = getValueFromKey(params, "partnerParams");
                for (i = 0; i < partnerParams.length; i = i+2) {
                    key = partnerParams[i];
                    value = partnerParams[i+1];
                    adjustEvent.addPartnerParameter(key, value);
                }
            }
            if (params["deduplicationId"] != null) {
                var deduplicationId:String = getFirstParameterValue(params, "deduplicationId");
                adjustEvent.setDeduplicationId(deduplicationId);
            }
            if (params["callbackId"] != null) {
                var callbackId:String = getFirstParameterValue(params, "callbackId");
                adjustEvent.setCallbackId(callbackId);
            }
            if (params["orderId"] != null) {
                var orderId:String = getFirstParameterValue(params, "orderId");
                adjustEvent.setTransactionId(orderId);
            }
            if (params["transactionId"] != null) {
                var transactionId:String = getFirstParameterValue(params, "transactionId");
                adjustEvent.setTransactionId(transactionId);
            }
            if (params["productId"] != null) {
                var productId:String = getFirstParameterValue(params, "productId");
                adjustEvent.setProductId(productId);
            }
            if (params["purchaseToken"] != null) {
                var purchaseToken:String = getFirstParameterValue(params, "purchaseToken");
                adjustEvent.setPurchaseToken(purchaseToken);
            }
        }

        private function trackEvent(params:Object):void {
            this.eventFunc(params);
            var eventNumber:int = 0
                if (params["eventName"] != null) {
                    var eventName:String = getFirstParameterValue(params, "eventName");
                    eventNumber = parseInt(eventName.substr(eventName.length - 1));
                }

            var adjustEvent:AdjustEvent = this.savedEvents[eventNumber];
            Adjust.trackEvent(adjustEvent);
            delete this.savedEvents[0];
        }

        private function pause(params:Object):void {
            Adjust.onPause();
        }

        private function resume(params:Object):void {
            Adjust.onResume();
        }

        private function setEnabled(params:Object):void {
            var enabled:Boolean = getFirstParameterValue(params, "enabled") === "true";
            if (enabled == true) {
                Adjust.enable();
            } else {
                Adjust.disable();
            }
        }

        private function setOfflineMode(params:Object):void {
            var offline:Boolean = getFirstParameterValue(params, "enabled") === "true";
            if (offline == true) {
                Adjust.switchToOfflineMode();
            } else {
                Adjust.switchBackToOnlineMode();
            }
        }

        private function addGlobalCallbackParameter(params:Object):void {
            var list:Array = getValueFromKey(params, "KeyValue");
            for (var i:int = 0; i < list.length; i = i+2) {
                var key:String = list[i];
                var value:String = list[i+1];
                Adjust.addGlobalCallbackParameter(key, value);
            }
        }

        private function addGlobalPartnerParameter(params:Object):void {
            var list:Array = getValueFromKey(params, "KeyValue");
            for (var i:int = 0; i < list.length; i = i+2) {
                var key:String = list[i];
                var value:String = list[i+1];
                Adjust.addGlobalPartnerParameter(key, value);
            }
        }

        private function removeGlobalCallbackParameter(params:Object):void {
            var list:Array = getValueFromKey(params, "key");
            for (var i:int = 0; i < list.length; i = i+1) {
                var key:String = list[i];
                Adjust.removeGlobalCallbackParameter(key);
            }
        }

        private function removeGlobalPartnerParameter(params:Object):void {
            var list:Array = getValueFromKey(params, "key");
            for (var i:int = 0; i < list.length; i = i+1) {
                var key:String = list[i];
                Adjust.removeGlobalPartnerParameter(key);
            }
        }

        private function removeGlobalCallbackParameters(params:Object):void {
            Adjust.removeGlobalCallbackParameters();
        }

        private function removeGlobalPartnerParameters(params:Object):void {
            Adjust.removeGlobalPartnerParameters();
        }

        private function setPushToken(params:Object):void {
            var pushToken:String = getFirstParameterValue(params, "pushToken");
            Adjust.setPushToken(pushToken);
        }

        private function openDeeplink(params:Object):void {
            var deeplink:String = getFirstParameterValue(params, "deeplink");
            var adjustDeeplink:AdjustDeeplink = new AdjustDeeplink(deeplink);
            Adjust.processDeeplink(adjustDeeplink);
        }

        private function gdprForgetMe(params:Object):void {
            Adjust.gdprForgetMe();
        }

        private function trackAdRevenue(params:Object):void {
            var source:String = null;

            if (params["adRevenueSource"] != null) {
                source = getFirstParameterValue(params, "adRevenueSource");
            }

            var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue(source);

            if (params["revenue"] != null) {
                var revenueParams:Array = getValueFromKey(params, "revenue");
                var currency:String = revenueParams[0];
                var revenue:Number = Number(revenueParams[1]);
                adjustAdRevenue.setRevenue(revenue, currency);
            }
            if (params["adImpressionsCount"] != null) {
                var strAdImpressionsCount:String = getFirstParameterValue(params, "adImpressionsCount");
                var adImpressionsCount:int = parseInt(strAdImpressionsCount);
                adjustAdRevenue.setAdImpressionsCount(adImpressionsCount);
            }
            if (params["adRevenueUnit"] != null) {
                var adRevenueUnit:String = getFirstParameterValue(params, "adRevenueUnit");
                adjustAdRevenue.setAdRevenueUnit(adRevenueUnit);
            }
            if (params["adRevenuePlacement"] != null) {
                var adRevenuePlacement:String = getFirstParameterValue(params, "adRevenuePlacement");
                adjustAdRevenue.setAdRevenuePlacement(adRevenuePlacement);
            }
            if (params["adRevenueNetwork"] != null) {
                var adRevenueNetwork:String = getFirstParameterValue(params, "adRevenueNetwork");
                adjustAdRevenue.setAdRevenueNetwork(adRevenueNetwork);
            }
            if (params["callbackParams"] != null) {
                var callbackParams:Array = getValueFromKey(params, "callbackParams");
                for (var i:int = 0; i < callbackParams.length; i = i+2) {
                    var key:String = callbackParams[i];
                    var value:String = callbackParams[i+1];
                    adjustAdRevenue.addCallbackParameter(key, value);
                }
            }
            if (params["partnerParams"] != null) {
                var partnerParams:Array = getValueFromKey(params, "partnerParams");
                for (i = 0; i < partnerParams.length; i = i+2) {
                    key = partnerParams[i];
                    value = partnerParams[i+1];
                    adjustAdRevenue.addPartnerParameter(key, value);
                }
            }
            
            Adjust.trackAdRevenue(adjustAdRevenue);
        }

        private function trackMeasurementConsent(params:Object):void {
            var isEnabled:Boolean = getFirstParameterValue(params, "isEnabled") === "true";
            Adjust.trackMeasurementConsent(isEnabled);
        }

        private function trackThirdPartySharing(params:Object):void {
            var isEnabled:String = null;
            if (getFirstParameterValue(params, "isEnabled") != null) {
                isEnabled = getFirstParameterValue(params, "isEnabled");
            }

            var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(isEnabled);

            if (params["granularOptions"] != null) {
                var granularOptions:Array = getValueFromKey(params, "granularOptions");
                for (var i:int = 0; i < granularOptions.length; i = i + 3) {
                    var partnerName:String = granularOptions[i];
                    var key:String = granularOptions[i+1];
                    var value:String = granularOptions[i+2];
                    adjustThirdPartySharing.addGranularOption(partnerName, key, value);
                }
            }

            if (params["partnerSharingSettings"] != null) {
                var partnerSharingSettings:Array = getValueFromKey(params, "partnerSharingSettings");
                for (i = 0; i < partnerSharingSettings.length; i = i + 3) {
                    partnerName = partnerSharingSettings[i];
                    key = partnerSharingSettings[i+1];
                    var boolValue:Boolean = partnerSharingSettings[i+2] == "true";
                    adjustThirdPartySharing.addPartnerSharingSetting(partnerName, key, boolValue);
                }
            }

            Adjust.trackThirdPartySharing(adjustThirdPartySharing);
        }

        private function attributionGetter(params:Object):void {
            Adjust.getAttribution(function (attribution:AdjustAttribution):void {
                AdjustTest.addInfoToSend("tracker_token", attribution.getTrackerToken());
                AdjustTest.addInfoToSend("tracker_name", attribution.getTrackerName());
                AdjustTest.addInfoToSend("network", attribution.getNetwork());
                AdjustTest.addInfoToSend("campaign", attribution.getCampaign());
                AdjustTest.addInfoToSend("adgroup", attribution.getAdGroup());
                AdjustTest.addInfoToSend("creative", attribution.getCreative());
                AdjustTest.addInfoToSend("click_label", attribution.getClickLabel());
                AdjustTest.addInfoToSend("cost_type", attribution.getCostType());
                AdjustTest.addInfoToSend(
                    "cost_amount",
                    isNaN(attribution.getCostAmount()) ? null : attribution.getCostAmount().toString());
                AdjustTest.addInfoToSend("cost_currency", attribution.getCostCurrency());
                AdjustTest.addInfoToSend("fb_install_referrer", attribution.getFbInstallReferrer());
                AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
            });
        }

        private function getLastDeeplink(params:Object):void {
            Adjust.getLastDeeplink(function (lastDeeplink:String):void {
                AdjustTest.addInfoToSend("last_deeplink", lastDeeplink);
                AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
            });
        }

        private function processDeeplink(params:Object):void {
            var deeplink:String = getFirstParameterValue(params, "deeplink");
            var adjustDeeplink:AdjustDeeplink = new AdjustDeeplink(deeplink);
            Adjust.processAndResolveDeeplink(adjustDeeplink, function (resolvedLink:String):void {
                AdjustTest.addInfoToSend("resolved_link", resolvedLink);
                AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
            });
        }

        private function verifyPurchase(params:Object):void {
            var productId:String = null;
            var purchaseToken:String = null;
            var transactionId:String = null;

            if (params["productId"] != null) {
                productId = getFirstParameterValue(params, "productId");
            }
            if (params["transactionId"] != null) {
                transactionId = getFirstParameterValue(params, "transactionId");
            }
            if (params["purchaseToken"] != null) {
                purchaseToken = getFirstParameterValue(params, "purchaseToken");
            }

            if (transactionId != null) {
                // ios
                var appStorePurchase:AdjustAppStorePurchase = new AdjustAppStorePurchase(productId, transactionId);
                Adjust.verifyAppStorePurchase(appStorePurchase, function (verificationResult:AdjustPurchaseVerificationResult):void {
                    AdjustTest.addInfoToSend("verification_status", verificationResult.getVerificationStatus());
                    AdjustTest.addInfoToSend("message", verificationResult.getMessage());
                    AdjustTest.addInfoToSend("code", verificationResult.getCode().toString());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            } else {
                // android
                var playStorePurchase:AdjustPlayStorePurchase = new AdjustPlayStorePurchase(productId, purchaseToken);
                Adjust.verifyPlayStorePurchase(playStorePurchase, function (verificationResult:AdjustPurchaseVerificationResult):void {
                    AdjustTest.addInfoToSend("verification_status", verificationResult.getVerificationStatus());
                    AdjustTest.addInfoToSend("message", verificationResult.getMessage());
                    AdjustTest.addInfoToSend("code", verificationResult.getCode().toString());
                    AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
                });
            }
        }

        private function trackSubscription(params:Object):void {
            var price:String = null;
            var currency:String = null;
            // ios
            var transactionId:String = null;
            var transactionDate:String = null;
            var salesRegion:String = null;
            // android
            var sku:String = null;
            var signature:String = null;
            var purchaseToken:String = null;
            var orderId:String = null;
            var purchaseTime:String = null;

            if (params["revenue"] != null) {
                price = getFirstParameterValue(params, "revenue");
            }
            if (params["currency"] != null) {
                currency = getFirstParameterValue(params, "currency");
            }
            // ios
            if (params["transactionId"] != null) {
                transactionId = getFirstParameterValue(params, "transactionId");
            }
            if (params["transactionDate"] != null) {
                transactionDate = getFirstParameterValue(params, "transactionDate");
            }
            if (params["salesRegion"] != null) {
                salesRegion = getFirstParameterValue(params, "salesRegion");
            }
            // android
            if (params["productId"] != null) {
                sku = getFirstParameterValue(params, "productId");
            }
            if (params["receipt"] != null) {
                signature = getFirstParameterValue(params, "receipt");
            }
            if (params["purchaseToken"] != null) {
                purchaseToken = getFirstParameterValue(params, "purchaseToken");
            }
            if (params["transactionId"] != null) {
                orderId = getFirstParameterValue(params, "transactionId");
            }
            if (params["transactionDate"] != null) {
                purchaseTime = getFirstParameterValue(params, "transactionDate");
            }

            if (salesRegion != null) {
                // ios
                var appStoreSubscription:AdjustAppStoreSubscription = new AdjustAppStoreSubscription(
                    price,
                    currency,
                    transactionId);
                appStoreSubscription.setTransactionDate(transactionDate);
                appStoreSubscription.setSalesRegion(salesRegion);
                if (params["callbackParams"] != null) {
                    var callbackParams:Array = getValueFromKey(params, "callbackParams");
                    for (var i:int = 0; i < callbackParams.length; i = i+2) {
                        var key:String = callbackParams[i];
                        var value:String = callbackParams[i+1];
                        appStoreSubscription.addCallbackParameter(key, value);
                    }
                }
                if (params["partnerParams"] != null) {
                    var partnerParams:Array = getValueFromKey(params, "partnerParams");
                    for (i = 0; i < partnerParams.length; i = i+2) {
                        key = partnerParams[i];
                        value = partnerParams[i+1];
                        appStoreSubscription.addPartnerParameter(key, value);
                    }
                }
                Adjust.trackAppStoreSubscription(appStoreSubscription);
            } else {
                // android
                var playStoreSubscription:AdjustPlayStoreSubscription = new AdjustPlayStoreSubscription(
                    price,
                    currency,
                    sku,
                    orderId,
                    signature,
                    purchaseToken);
                playStoreSubscription.setPurchaseTime(purchaseTime);
                if (params["callbackParams"] != null) {
                    callbackParams = getValueFromKey(params, "callbackParams");
                    for (i = 0; i < callbackParams.length; i = i+2) {
                        key = callbackParams[i];
                        value = callbackParams[i+1];
                        playStoreSubscription.addCallbackParameter(key, value);
                    }
                }
                if (params["partnerParams"] != null) {
                    partnerParams = getValueFromKey(params, "partnerParams");
                    for (i = 0; i < partnerParams.length; i = i+2) {
                        key = partnerParams[i];
                        value = partnerParams[i+1];
                        playStoreSubscription.addPartnerParameter(key, value);
                    }
                }
                Adjust.trackPlayStoreSubscription(playStoreSubscription);
            }
        }

        private function verifyTrack(params:Object):void {
            this.eventFunc(params);
            var eventNumber:int = 0
            if (params["eventName"] != null) {
                var eventName:String = getFirstParameterValue(params, "eventName");
                eventNumber = parseInt(eventName.substr(eventName.length - 1));
            }
            var adjustEvent:AdjustEvent = this.savedEvents[eventNumber];
            // Adjust.verifyAndTrackPlayStorePurchase(
            Adjust.verifyAndTrackAppStorePurchase(
                adjustEvent,
                function (verificationResult:AdjustPurchaseVerificationResult):void {
                AdjustTest.addInfoToSend("verification_status", verificationResult.getVerificationStatus());
                AdjustTest.addInfoToSend("message", verificationResult.getMessage());
                AdjustTest.addInfoToSend("code", verificationResult.getCode().toString());
                AdjustTest.sendInfoToServer(AdjustCommandExecutor.extraPath);
            });
        }

        private function getValueFromKey(params:Object, key:String):Array {
            if (params[key] != null) {
                return params[key];
            }
            return null;
        }

        private function getFirstParameterValue(params:Object, key:String):String {
            if (params[key] != null) {
                var param:Array = params[key];
                if (param != null && param.length >= 1) {
                    return param[0];
                }
            }
            return null;
        }
    }
}
