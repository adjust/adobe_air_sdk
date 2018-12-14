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
    import com.adjust.sdk.Environment;
    import com.adjust.sdk.LogLevel;
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
        public static var basePath:String;
        public static var gdprPath:String;
        private var savedEvents:Dictionary;
        private var savedConfigs:Dictionary;
        private var savedCommands:Array;
        private var nextToSendCounter:int;

        public function AdjustCommandExecutor(baseUrl:String) {
            this.savedEvents = new Dictionary();
            this.savedConfigs = new Dictionary();
            this.savedCommands = new Array();
            this.nextToSendCounter = 0;
            AdjustCommandExecutor.basePath = null;
            AdjustCommandExecutor.gdprPath = null;
        }

        // First point of entry for scheduling commands. Takes a 'AdjustCommand {command}' parameter
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
                case "setReferrer" : this.setReferrer(command.params); break;
                case "setOfflineMode" : this.setOfflineMode(command.params); break;
                case "sendFirstPackages" : this.sendFirstPackages(command.params); break;
                case "addSessionCallbackParameter" : this.addSessionCallbackParameter(command.params); break;
                case "addSessionPartnerParameter" : this.addSessionPartnerParameter(command.params); break;
                case "removeSessionCallbackParameter" : this.removeSessionCallbackParameter(command.params); break;
                case "removeSessionPartnerParameter" : this.removeSessionPartnerParameter(command.params); break;
                case "resetSessionCallbackParameters" : this.resetSessionCallbackParameters(command.params); break;
                case "resetSessionPartnerParameters" : this.resetSessionPartnerParameters(command.params); break;
                case "setPushToken" : this.setPushToken(command.params); break;
                case "openDeeplink" : this.openDeeplink(command.params); break;
                case "sendReferrer" : this.sendReferrer(command.params); break;
                case "gdprForgetMe" : this.gdprForgetMe(command.params); break;
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
            testOptions.baseUrl = Main.baseUrl;
            testOptions.gdprUrl = Main.gdprUrl;

            if (params['basePath'] != null) {
                AdjustCommandExecutor.basePath = getFirstParameterValue(params, 'basePath');
                AdjustCommandExecutor.gdprPath = getFirstParameterValue(params, 'basePath');
            }
            if (params['timerInterval'] != null) {
                testOptions.timerIntervalInMilliseconds = getFirstParameterValue(params, 'timerInterval');
            }
            if (params['timerStart'] != null) {
                testOptions.timerStartInMilliseconds = getFirstParameterValue(params, 'timerStart');
            }
            if (params['sessionInterval'] != null) {
                testOptions.sessionIntervalInMilliseconds = getFirstParameterValue(params, 'sessionInterval');
            }
            if (params['subsessionInterval'] != null) {
                testOptions.subsessionIntervalInMilliseconds = getFirstParameterValue(params, 'subsessionInterval');
            }
            if (params['tryInstallReferrer'] != null) {
                testOptions.tryInstallReferrer = getFirstParameterValue(params, 'tryInstallReferrer') == "true";
            }
            if (params['noBackoffWait'] != null) {
                testOptions.noBackoffWait = getFirstParameterValue(params, 'noBackoffWait') == "true";
            }
            if (params['teardown'] != null) {
                var teardownOptions:Array = getValueFromKey(params, 'teardown');
                for (var i:int = 0; i < teardownOptions.length; i++) {
                    var option:String = teardownOptions[i];

                    if ('resetSdk' === option) {
                        testOptions.teardown = true;
                        testOptions.useTestConnectionOptions = true;
                        testOptions.tryInstallReferrer = false;
                        testOptions.basePath = AdjustCommandExecutor.basePath;
                        testOptions.gdprPath = AdjustCommandExecutor.gdprPath;
                    }
                    if ('deleteState' === option) {
                        testOptions.hasContext = true;
                    }
                    if ('resetTest' === option) {
                        this.savedEvents = new Dictionary();
                        this.savedConfigs = new Dictionary();
                        testOptions.timerIntervalInMilliseconds = "-1";
                        testOptions.timerStartInMilliseconds = "-1";
                        testOptions.sessionIntervalInMilliseconds = "-1";
                        testOptions.subsessionIntervalInMilliseconds = "-1";
                    }
                    if ('sdk' === option) {
                        testOptions.teardown = true;
                        testOptions.basePath = null;
                        testOptions.gdprPath = null;
                        testOptions.useTestConnectionOptions = false;
                    }
                    if ('test' === option) {
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
            Adjust.teardown();
        }

        private function config(params:Object):void {
            var configNumber:int = 0
                if (params['configName'] != null) {
                    var configName:String = getFirstParameterValue(params, 'configName');
                    configNumber = parseInt(configName.substr(configName.length - 1));
                }
            var adjustConfig:AdjustConfig;
            if (this.savedConfigs[configNumber] != null) {
                adjustConfig = this.savedConfigs[configNumber];
            } else {
                var environment:String = getFirstParameterValue(params, "environment");
                var appToken:String = getFirstParameterValue(params, "appToken");
                adjustConfig = new AdjustConfig(appToken, environment);
                adjustConfig.setLogLevel(LogLevel.VERBOSE);
                this.savedConfigs[configNumber] = adjustConfig;
            }
            if (params['logLevel'] != null) {
                var logLevel:String = getFirstParameterValue(params, 'logLevel');
                adjustConfig.setLogLevel(logLevel);
            }
            if (params['defaultTracker'] != null) {
                var defaultTracker:String = getFirstParameterValue(params, 'defaultTracker');
                adjustConfig.setDefaultTracker(defaultTracker);
            }
            if (params['appSecret'] != null) {
                var appSecretArray:Array = getValueFromKey(params, 'appSecret');
                var secretId:Number = Number(appSecretArray[0].toString());
                var info1:Number = Number(appSecretArray[1].toString());
                var info2:Number = Number(appSecretArray[2].toString());
                var info3:Number = Number(appSecretArray[3].toString());
                var info4:Number = Number(appSecretArray[4].toString());
                adjustConfig.setAppSecret(secretId, info1, info2, info3, info4);
            }
            if (params['delayStart'] != null) {
                var delayStartS:String = getFirstParameterValue(params, 'delayStart');
                var delayStart:Number = Number(delayStartS);
                adjustConfig.setDelayStart(delayStart);
            }
            if (params['eventBufferingEnabled'] != null) {
                var eventBufferingEnabledS:String = getFirstParameterValue(params, 'eventBufferingEnabled');
                var eventBufferingEnabled:Boolean = (eventBufferingEnabledS === 'true');
                adjustConfig.setEventBufferingEnabled(eventBufferingEnabled);
            }
            if (params['sendInBackground'] != null) {
                var sendInBackgroundS:String = getFirstParameterValue(params, 'sendInBackground');
                var sendInBackground:Boolean = (sendInBackgroundS === 'true');
                adjustConfig.setSendInBackground(sendInBackground);
            }
            if (params['userAgent'] != null) {
                var userAgent:String = getFirstParameterValue(params, 'userAgent');
                adjustConfig.setUserAgent(userAgent);
            }
            if (params['attributionCallbackSendAll'] != null) {
                adjustConfig.setAttributionCallbackDelegate(attributionCallbackDelegate);
            }
            if (params['sessionCallbackSendSuccess'] != null) {
                adjustConfig.setSessionTrackingSucceededDelegate(sessionTrackingSucceededDelegate);
            }
            if (params['sessionCallbackSendFailure'] != null) {
                adjustConfig.setSessionTrackingFailedDelegate(sessionTrackingFailedDelegate);
            }
            if (params['eventCallbackSendSuccess'] != null) {
                adjustConfig.setEventTrackingSucceededDelegate(eventTrackingSucceededDelegate);
            }
            if (params['eventCallbackSendFailure'] != null) {
                adjustConfig.setEventTrackingFailedDelegate(eventTrackingFailedDelegate);
            }
        }

        private function start(params:Object):void {
            this.config(params);
            var configNumber:int = 0
                if (params['configName'] != null) {
                    var configName:String = getFirstParameterValue(params, 'configName');
                    configNumber = parseInt(configName.substr(configName.length - 1));
                }

            var adjustConfig:AdjustConfig = this.savedConfigs[configNumber];
            Adjust.start(adjustConfig);
            delete this.savedConfigs[0];
        }

        private function eventFunc(params:Object):void {
            var eventNumber:int = 0
                if (params['eventName'] != null) {
                    var eventName:String = getFirstParameterValue(params, 'eventName');
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
            if (params['revenue'] != null) {
                var revenueParams:Array = getValueFromKey(params, 'revenue');
                var currency:String = revenueParams[0];
                var revenue:Number = Number(revenueParams[1]);
                adjustEvent.setRevenue(revenue, currency);
            }
            if (params['callbackParams'] != null) {
                var callbackParams:Array = getValueFromKey(params, "callbackParams");
                for (var i:int = 0; i < callbackParams.length; i = i+2) {
                    var key:String = callbackParams[i];
                    var value:String = callbackParams[i+1];
                    adjustEvent.addCallbackParameter(key, value);
                }
            }
            if (params['partnerParams'] != null) {
                var partnerParams:Array = getValueFromKey(params, "partnerParams");
                for (i = 0; i < partnerParams.length; i = i+2) {
                    key = partnerParams[i];
                    value = partnerParams[i+1];
                    adjustEvent.addPartnerParameter(key, value);
                }
            }
            if (params['orderId'] != null) {
                var orderId:String = getFirstParameterValue(params, 'orderId');
                adjustEvent.setTransactionId(orderId);
            }
            if (params['callbackId'] != null) {
                var callbackId:String = getFirstParameterValue(params, 'callbackId');
                adjustEvent.setCallbackId(callbackId);
            }
        }

        private function trackEvent(params:Object):void {
            this.eventFunc(params);
            var eventNumber:int = 0
                if (params['eventName'] != null) {
                    var eventName:String = getFirstParameterValue(params, 'eventName');
                    eventNumber = parseInt(eventName.substr(eventName.length - 1));
                }

            var adjustEvent:AdjustEvent = this.savedEvents[eventNumber];
            Adjust.trackEvent(adjustEvent);
            delete this.savedEvents[0];
        }

        private function setReferrer(params:Object):void {
            var referrer:String = getFirstParameterValue(params, 'referrer');
            Adjust.setReferrer(referrer);
        }

        private function pause(params:Object):void {
            Adjust.onPause(null);
        }

        private function resume(params:Object):void {
            Adjust.onResume(null);
        }

        private function setEnabled(params:Object):void {
            var enabled:Boolean = getFirstParameterValue(params, "enabled") === 'true';
            Adjust.setEnabled(enabled);
        }

        private function setOfflineMode(params:Object):void {
            var enabled:Boolean = getFirstParameterValue(params, "enabled") === 'true';
            Adjust.setOfflineMode(enabled);
        }

        private function sendFirstPackages(params:Object):void {
            Adjust.sendFirstPackages();
        }

        private function addSessionCallbackParameter(params:Object):void {
            var list:Array = getValueFromKey(params, 'KeyValue');
            for (var i:int = 0; i < list.length; i = i+2) {
                var key:String = list[i];
                var value:String = list[i+1];
                Adjust.addSessionCallbackParameter(key, value);
            }
        }

        private function addSessionPartnerParameter(params:Object):void {
            var list:Array = getValueFromKey(params, 'KeyValue');
            for (var i:int = 0; i < list.length; i = i+2) {
                var key:String = list[i];
                var value:String = list[i+1];
                Adjust.addSessionPartnerParameter(key, value);
            }
        }

        private function removeSessionCallbackParameter(params:Object):void {
            var list:Array = getValueFromKey(params, 'key');
            for (var i:int = 0; i < list.length; i = i+1) {
                var key:String = list[i];

                Adjust.removeSessionCallbackParameter(key);
            }
        }

        private function removeSessionPartnerParameter(params:Object):void {
            var list:Array = getValueFromKey(params, 'key');
            for (var i:int = 0; i < list.length; i = i+1) {
                var key:String = list[i];
                Adjust.removeSessionPartnerParameter(key);
            }
        }

        private function resetSessionCallbackParameters(params:Object):void {
            Adjust.resetSessionCallbackParameters();
        }

        private function resetSessionPartnerParameters(params:Object):void {
            Adjust.resetSessionPartnerParameters();
        }

        private function setPushToken(params:Object):void {
            var token:String = getFirstParameterValue(params, 'pushToken');
            Adjust.setDeviceToken(token);
        }

        private function openDeeplink(params:Object):void {
            var deeplink:String = getFirstParameterValue(params, "deeplink");
            Adjust.appWillOpenUrl(deeplink);
        }

        private function sendReferrer(params:Object):void {
            var referrer:String = getFirstParameterValue(params, 'referrer');
            Adjust.setReferrer(referrer);
        }

        private function gdprForgetMe(params:Object):void {
            Adjust.gdprForgetMe();
        }

        private function attributionCallbackDelegate(attribution:AdjustAttribution):void {
            AdjustTest.addInfoToSend("trackerToken", attribution.getTrackerToken());
            AdjustTest.addInfoToSend("trackerName", attribution.getTrackerName());
            AdjustTest.addInfoToSend("network", attribution.getNetwork());
            AdjustTest.addInfoToSend("campaign", attribution.getCampaign());
            AdjustTest.addInfoToSend("adgroup", attribution.getAdGroup());
            AdjustTest.addInfoToSend("creative", attribution.getCreative());
            AdjustTest.addInfoToSend("clickLabel", attribution.getClickLabel());
            AdjustTest.addInfoToSend("adid", attribution.getAdid());
            AdjustTest.sendInfoToServer(AdjustCommandExecutor.basePath);
        }

        private function eventTrackingSucceededDelegate(eventSuccess:AdjustEventSuccess):void {
            AdjustTest.addInfoToSend("message", eventSuccess.getMessage());
            AdjustTest.addInfoToSend("timestamp", eventSuccess.getTimeStamp());
            AdjustTest.addInfoToSend("adid", eventSuccess.getAdid());
            AdjustTest.addInfoToSend("eventToken", eventSuccess.getEventToken());
            AdjustTest.addInfoToSend("callbackId", eventSuccess.getCallbackId());
            AdjustTest.addInfoToSend("jsonResponse", eventSuccess.getJsonResponse());
            AdjustTest.sendInfoToServer(AdjustCommandExecutor.basePath);
        }

        private function eventTrackingFailedDelegate(eventFail:AdjustEventFailure):void {
            AdjustTest.addInfoToSend("message", eventFail.getMessage());
            AdjustTest.addInfoToSend("timestamp", eventFail.getTimeStamp());
            AdjustTest.addInfoToSend("adid", eventFail.getAdid());
            AdjustTest.addInfoToSend("eventToken", eventFail.getEventToken());
            AdjustTest.addInfoToSend("callbackId", eventFail.getCallbackId());
            AdjustTest.addInfoToSend("willRetry", eventFail.getWillRetry().toString());
            AdjustTest.addInfoToSend("jsonResponse", eventFail.getJsonResponse());
            AdjustTest.sendInfoToServer(AdjustCommandExecutor.basePath);
        }

        private function sessionTrackingSucceededDelegate(sessionSuccess:AdjustSessionSuccess):void {
            AdjustTest.addInfoToSend("message", sessionSuccess.getMessage());
            AdjustTest.addInfoToSend("timestamp", sessionSuccess.getTimeStamp());
            AdjustTest.addInfoToSend("adid", sessionSuccess.getAdid());
            AdjustTest.addInfoToSend("jsonResponse", sessionSuccess.getJsonResponse());
            AdjustTest.sendInfoToServer(AdjustCommandExecutor.basePath);
        }

        private function sessionTrackingFailedDelegate(sessionFail:AdjustSessionFailure):void {
            AdjustTest.addInfoToSend("message", sessionFail.getMessage());
            AdjustTest.addInfoToSend("timestamp", sessionFail.getTimeStamp());
            AdjustTest.addInfoToSend("adid", sessionFail.getAdid());
            AdjustTest.addInfoToSend("willRetry", sessionFail.getWillRetry().toString());
            AdjustTest.addInfoToSend("jsonResponse", sessionFail.getJsonResponse());
            AdjustTest.sendInfoToServer(AdjustCommandExecutor.basePath);
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
