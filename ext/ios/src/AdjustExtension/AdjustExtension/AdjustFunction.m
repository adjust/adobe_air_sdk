//
//  AdjustFunction.m
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-Present Adjust GmbH. All rights reserved.
//

#import "AdjustFunction.h"
#import "AdjustFREUtils.h"
#import "AdjustSdkDelegate.h"

FREContext adjustFREContext;
BOOL shouldLaunchDeferredDeeplink = YES;

@implementation AdjustFunction

@end

#pragma mark - Common methods

FREObject ADJinitSdk(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 33) {
        NSString *appToken = nil;
        NSString *environment = nil;
        NSString *strLogLevel = nil;
        BOOL allowSuppressLogLevel = NO;

        adjustFREContext = ctx;

        // app token [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &appToken);
        }
        // environment [1]
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &environment);
        }
        // log level [2]
        if (argv[2] != nil) {
            FREGetObjectAsNativeString(argv[2], &strLogLevel);
            if (strLogLevel != nil) {
                if ([strLogLevel isEqualToString:@"suppress"]) {
                    allowSuppressLogLevel = YES;
                }
            }
        }

        ADJConfig *adjustConfig = [[ADJConfig alloc] initWithAppToken:appToken
                                                          environment:environment
                                                     suppressLogLevel:allowSuppressLogLevel];

        if (strLogLevel != nil) {
            [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[strLogLevel lowercaseString]]];
        }
        // SDK prefix
        if (argv[3] != nil) {
            NSString *sdkPrefix = nil;
            FREGetObjectAsNativeString(argv[3], &sdkPrefix);
            [adjustConfig setSdkPrefix:sdkPrefix];
        }
        // default tracker [4]
        if (argv[4] != nil) {
            NSString *defaultTracker = nil;
            FREGetObjectAsNativeString(argv[4], &defaultTracker);
            [adjustConfig setDefaultTracker:defaultTracker];
        }
        // external device ID [5]
        if (argv[5] != nil) {
            NSString *externalDeviceId = nil;
            FREGetObjectAsNativeString(argv[5], &externalDeviceId);
            [adjustConfig setExternalDeviceId:externalDeviceId];
        }
        // COPPA compliance [6]
        if (argv[6] != nil) {
            BOOL isCoppaComplianceEnabled = NO;
            FREGetObjectAsNativeBool(argv[6], &isCoppaComplianceEnabled);
            if (YES == isCoppaComplianceEnabled) {
                [adjustConfig enableCoppaCompliance];
            }
        }
        // sending in background [7]
        if (argv[7] != nil) {
            BOOL isSendingInBackgroundEnabled = NO;
            FREGetObjectAsNativeBool(argv[7], &isSendingInBackgroundEnabled);
            if (YES == isSendingInBackgroundEnabled) {
                [adjustConfig enableSendingInBackground];
            }
        }
        // should open deferred deep link [8]
        if (argv[8] != nil) {
            FREGetObjectAsNativeBool(argv[8], &shouldLaunchDeferredDeeplink);
        }
        // cost data in attribution [9]
        if (argv[9] != nil) {
            BOOL isCostDataInAttributionEnabled = NO;
            FREGetObjectAsNativeBool(argv[9], &isCostDataInAttributionEnabled);
            if (YES == isCostDataInAttributionEnabled) {
                [adjustConfig enableCostDataInAttribution];
            }
        }
        // read device IDs only once
        if (argv[10] != nil) {
            BOOL isDeviceIdsReadingOnceEnabled = NO;
            FREGetObjectAsNativeBool(argv[10], &isDeviceIdsReadingOnceEnabled);
            if (YES == isDeviceIdsReadingOnceEnabled) {
                [adjustConfig enableDeviceIdsReadingOnce];
            }
        }
        // attribution callback [11]
        BOOL isAttributionCallbackImplemented = NO;
        if (argv[11] != nil) {
            FREGetObjectAsNativeBool(argv[11], &isAttributionCallbackImplemented);
        }
        // event success callback [12]
        BOOL isEventSuccessCallbackImplemented = NO;
        if (argv[12] != nil) {
            FREGetObjectAsNativeBool(argv[12], &isEventSuccessCallbackImplemented);
        }
        // event failure callback [13]
        BOOL isEventFailureCallbackImplemented = NO;
        if (argv[13] != nil) {
            FREGetObjectAsNativeBool(argv[13], &isEventFailureCallbackImplemented);
        }
        // session success callback [14]
        BOOL isSessionSuccessCallbackImplemented = NO;
        if (argv[14] != nil) {
            FREGetObjectAsNativeBool(argv[14], &isSessionSuccessCallbackImplemented);
        }
        // session failure callback [15]
        BOOL isSessionFailureCallbackImplemented = NO;
        if (argv[15] != nil) {
            FREGetObjectAsNativeBool(argv[15], &isSessionFailureCallbackImplemented);
        }
        // deferred deep link callback [16]
        BOOL isDeferredDeeplinkCallbackImplemented = NO;
        if (argv[16] != nil) {
            FREGetObjectAsNativeBool(argv[16], &isDeferredDeeplinkCallbackImplemented);
        }
        // SKAN updated callback [32]
        BOOL isSkanUpdatedCallbackImplemented = NO;
        if (argv[32] != nil) {
            FREGetObjectAsNativeBool(argv[32], &isSkanUpdatedCallbackImplemented);
        }
        
        // set callbacks if needed
        if (isAttributionCallbackImplemented
            || isEventSuccessCallbackImplemented
            || isEventFailureCallbackImplemented
            || isSessionSuccessCallbackImplemented
            || isSessionFailureCallbackImplemented
            || isDeferredDeeplinkCallbackImplemented
            || isSkanUpdatedCallbackImplemented) {
            [adjustConfig setDelegate:
             [AdjustSdkDelegate getInstanceWithSwizzleOfAttributionCallback:isAttributionCallbackImplemented
                                                       eventSuccessCallback:isEventSuccessCallbackImplemented
                                                       eventFailureCallback:isEventFailureCallbackImplemented
                                                     sessionSuccessCallback:isSessionSuccessCallbackImplemented
                                                     sessionFailureCallback:isSessionFailureCallbackImplemented
                                                   deferredDeeplinkCallback:isDeferredDeeplinkCallbackImplemented
                                                        skanUpdatedCallback:isSkanUpdatedCallbackImplemented
                                               shouldLaunchDeferredDeeplink:shouldLaunchDeferredDeeplink
                                                             withFREContext:&adjustFREContext]];
        }

        // max number of deduplication IDs [17]
        if (argv[17] != nil) {
            int eventDedupliactionIdsMaxSize;
            FREGetObjectAsInt32(argv[17], &eventDedupliactionIdsMaxSize);
            [adjustConfig setEventDeduplicationIdsMaxSize:eventDedupliactionIdsMaxSize];
        }
        // URL strategy domains [18]
        // URL strategy use subdomains [19]
        // URL strategy is data residency [20]
        if (argv[18] != nil && argv[19] != nil && argv[20] != nil) {
            NSMutableArray *urlStrategyDomains = nil;
            BOOL useSubdomains;
            BOOL isDataResidency;
            FREGetObjectAsNativeArray(argv[18], &urlStrategyDomains);
            FREGetObjectAsNativeBool(argv[19], &useSubdomains);
            FREGetObjectAsNativeBool(argv[20], &isDataResidency);
            [adjustConfig setUrlStrategy:urlStrategyDomains
                           useSubdomains:useSubdomains
                         isDataResidency:isDataResidency];
        }
        // link me [26]
        if (argv[26] != nil) {
            BOOL isLinkMeEnabled = NO;
            FREGetObjectAsNativeBool(argv[26], &isLinkMeEnabled);
            if (YES == isLinkMeEnabled) {
                [adjustConfig enableLinkMe];
            }
        }
        // ad services [27]
        if (argv[27] != nil) {
            BOOL isAdServicesEnabled = YES;
            FREGetObjectAsNativeBool(argv[27], &isAdServicesEnabled);
            if (NO == isAdServicesEnabled) {
                [adjustConfig disableAdServices];
            }
        }
        // idfa reading [28]
        if (argv[28] != nil) {
            BOOL isIdfaReadingEnabled = YES;
            FREGetObjectAsNativeBool(argv[28], &isIdfaReadingEnabled);
            if (NO == isIdfaReadingEnabled) {
                [adjustConfig disableIdfaReading];
            }
        }
        // idfv reading [29]
        if (argv[29] != nil) {
            BOOL isIdfvReadingEnabled = YES;
            FREGetObjectAsNativeBool(argv[29], &isIdfvReadingEnabled);
            if (NO == isIdfvReadingEnabled) {
                [adjustConfig disableIdfvReading];
            }
        }
        // SKAN attribution [30]
        if (argv[30] != nil) {
            BOOL isSkanAttributionEnabled = YES;
            FREGetObjectAsNativeBool(argv[30], &isSkanAttributionEnabled);
            if (NO == isSkanAttributionEnabled) {
                [adjustConfig disableSkanAttribution];
            }
        }
        // ATT timer interval [31]
        if (argv[31] != nil) {
            int attConsentWaitingInterval;
            FREGetObjectAsInt32(argv[31], &attConsentWaitingInterval);
            [adjustConfig setAttConsentWaitingInterval:attConsentWaitingInterval];
        }

        [Adjust initSdk:adjustConfig];
    } else {
        NSLog(@"AdjustFunction: Bridge 'initSdk' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJenable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust enable];
    } else {
        NSLog(@"AdjustFunction: Bridge 'enable' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJdisable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust disable];
    } else {
        NSLog(@"AdjustFunction: Bridge 'disable' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJswitchToOfflineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust switchToOfflineMode];
    } else {
        NSLog(@"AdjustFunction: Bridge 'switchToOfflineMode' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJswitchBackToOnlineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust switchBackToOnlineMode];
    } else {
        NSLog(@"AdjustFunction: Bridge 'switchBackToOnlineMode' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 10) {
        NSString *eventToken = nil;

        // event token [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &eventToken);
        }

        ADJEvent *adjustEvent = [[ADJEvent alloc] initWithEventToken:eventToken];

        // revenue [1]
        // currency [2]
        if (argv[2] != nil) {
            NSString *currency = nil;
            FREGetObjectAsNativeString(argv[2], &currency);
            if (argv[1] != nil) {
                double revenue;
                FREGetObjectAsDouble(argv[1], &revenue);
                [adjustEvent setRevenue:revenue currency:currency];
            }
        }
        // callback ID [3]
        if (argv[3] != nil) {
            NSString *callbackId = nil;
            FREGetObjectAsNativeString(argv[3], &callbackId);
            [adjustEvent setCallbackId:callbackId];
        }
        // deduplication ID [4]
        if (argv[4] != nil) {
            NSString *deduplicationId = nil;
            FREGetObjectAsNativeString(argv[4], &deduplicationId);
            [adjustEvent setDeduplicationId:deduplicationId];
        }
        // produt ID [5]
        if (argv[5] != nil) {
            NSString *productId = nil;
            FREGetObjectAsNativeString(argv[5], &productId);
            [adjustEvent setProductId:productId];
        }
        // transaction ID [8]
        if (argv[8] != nil) {
            NSString *transactionId = nil;
            FREGetObjectAsNativeString(argv[8], &transactionId);
            [adjustEvent setTransactionId:transactionId];
        }
        // callback parameters [6]
        if (argv[6] != nil) {
            NSMutableArray *callbackParameters = nil;
            FREGetObjectAsNativeArray(argv[6], &callbackParameters);
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustEvent addCallbackParameter:key value:value];
            }
        }
        // partner parameters [7]
        if (argv[7] != nil) {
            NSMutableArray *partnerParameters = nil;
            FREGetObjectAsNativeArray(argv[7], &partnerParameters);
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustEvent addPartnerParameter:key value:value];
            }
        }

        [Adjust trackEvent:adjustEvent];
    } else {
        NSLog(@"AdjustFunction: Bridge 'trackEvent' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackAdRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 9) {
        NSString *source = nil;
        
        // source [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &source);
        }
        
        ADJAdRevenue *adjustAdRevenue = [[ADJAdRevenue alloc] initWithSource:source];
        
        // revenue [1]
        // currency [2]
        if (argv[2] != nil) {
            NSString *currency = nil;
            FREGetObjectAsNativeString(argv[2], &currency);
            if (argv[1] != nil) {
                double revenue;
                FREGetObjectAsDouble(argv[1], &revenue);
                [adjustAdRevenue setRevenue:revenue currency:currency];
            }
        }
        // ad impressions count [3]
        if (argv[3] != nil) {
            int adImpressionsCount;
            FREGetObjectAsInt32(argv[3], &adImpressionsCount);
            [adjustAdRevenue setAdImpressionsCount:adImpressionsCount];
        }
        // ad revenue network [4]
        if (argv[4] != nil) {
            NSString *adRevenueNetwork = nil;
            FREGetObjectAsNativeString(argv[4], &adRevenueNetwork);
            [adjustAdRevenue setAdRevenueNetwork:adRevenueNetwork];
        }
        // ad revenue unit [5]
        if (argv[5] != nil) {
            NSString *adRevenueUnit = nil;
            FREGetObjectAsNativeString(argv[5], &adRevenueUnit);
            [adjustAdRevenue setAdRevenueUnit:adRevenueUnit];
        }
        // ad revenue placement [6]
        if (argv[6] != nil) {
            NSString *adRevenuePlacement = nil;
            FREGetObjectAsNativeString(argv[6], &adRevenuePlacement);
            [adjustAdRevenue setAdRevenuePlacement:adRevenuePlacement];
        }
        // callback parameters [7]
        if (argv[7] != nil) {
            NSMutableArray *callbackParameters = nil;
            FREGetObjectAsNativeArray(argv[7], &callbackParameters);
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustAdRevenue addCallbackParameter:key value:value];
            }
        }
        // partner parameters [8]
        if (argv[8] != nil) {
            NSMutableArray *partnerParameters = nil;
            FREGetObjectAsNativeArray(argv[8], &partnerParameters);
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustAdRevenue addPartnerParameter:key value:value];
            }
        }
        
        [Adjust trackAdRevenue:adjustAdRevenue];
    } else {
        NSLog(@"AdjustFunction: Bridge 'trackAdRevenue' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackThirdPartySharing(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 3) {
        // isEnabled [0]
        NSNumber *isEnabled = nil;
        if (argv[0] != nil) {
            NSString *strIsEnabled = nil;
            FREGetObjectAsNativeString(argv[0], &strIsEnabled);
            if ([strIsEnabled isEqualToString:@"true"]) {
                isEnabled = @YES;
            } else if ([strIsEnabled isEqualToString:@"false"]) {
                isEnabled = @NO;
            }
        }

        ADJThirdPartySharing *adjustThirdPartySharing =
        [[ADJThirdPartySharing alloc] initWithIsEnabled:isEnabled];

        // granular options [1]
        if (argv[1] != nil) {
            NSMutableArray *granularOptions = nil;
            FREGetObjectAsNativeArray(argv[1], &granularOptions);
            for (int i = 0; i < [granularOptions count]; i += 3) {
                NSString *partnerName = [granularOptions objectAtIndex:i];
                NSString *key = [granularOptions objectAtIndex:(i+1)];
                NSString *value = [granularOptions objectAtIndex:(i+2)];
                if ([partnerName isEqualToString:@"ADJ__NULL"]) {
                    partnerName = nil;
                }
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustThirdPartySharing addGranularOption:partnerName
                                                       key:key
                                                     value:value];
            }
        }
        // partner sharig settings [2]
        if (argv[2] != nil) {
            NSMutableArray *partnerSharingSettings = nil;
            FREGetObjectAsNativeArray(argv[2], &partnerSharingSettings);
            for (int i = 0; i < [partnerSharingSettings count]; i += 3) {
                NSString *partnerName = [partnerSharingSettings objectAtIndex:i];
                NSString *key = [partnerSharingSettings objectAtIndex:(i+1)];
                NSString *value = [partnerSharingSettings objectAtIndex:(i+2)];
                if ([partnerName isEqualToString:@"ADJ__NULL"]) {
                    partnerName = nil;
                }
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                [adjustThirdPartySharing addPartnerSharingSetting:partnerName
                                                              key:key
                                                            value:[value boolValue]];
            }
        }

        [Adjust trackThirdPartySharing:adjustThirdPartySharing];
    } else {
        NSLog(@"AdjustFunction: Bridge 'trackThirdPartySharing' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackMeasurementConsent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        // measurement consent [0]
        if (argv[0] != nil) {
            BOOL measurementConsent;
            FREGetObjectAsNativeBool(argv[0], &measurementConsent);
            [Adjust trackMeasurementConsent:measurementConsent];
        }
    } else {
        NSLog(@"AdjustFunction: Bridge 'trackMeasurementConsent' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJprocessDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        // deeplink [0]
        if (argv[0] != nil) {
            NSString *deeplink = nil;
            FREGetObjectAsNativeString(argv[0], &deeplink);
            ADJDeeplink *adjustDeeplink = [[ADJDeeplink alloc] initWithDeeplink:[NSURL URLWithString:deeplink]];
            [Adjust processDeeplink:adjustDeeplink];
        }
    } else {
        NSLog(@"AdjustFunction: Bridge 'processDeeplink' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJprocessAndResolveDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        // deeplink [0]
        if (argv[0] != nil) {
            NSString *deeplink = nil;
            FREGetObjectAsNativeString(argv[0], &deeplink);
            ADJDeeplink *adjustDeeplink = [[ADJDeeplink alloc] initWithDeeplink:[NSURL URLWithString:deeplink]];
            [Adjust processAndResolveDeeplink:adjustDeeplink withCompletionHandler:^(NSString * _Nullable resolvedLink) {
                const char* cResponseData = [resolvedLink UTF8String];
                FREDispatchStatusEventAsync(ctx,
                        (const uint8_t *)"adjust_processAndResolveDeeplink",
                        (const uint8_t *)cResponseData);
            }];
        }
    } else {
        NSLog(@"AdjustFunction: Bridge 'processAndResolveDeeplink' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetPushToken(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *pushToken;
        FREGetObjectAsNativeString(argv[0], &pushToken);
        [Adjust setPushTokenAsString:pushToken];
    } else {
        NSLog(@"AdjustFunction: Bridge 'setPushToken' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgdprForgetMe(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust gdprForgetMe];
    } else {
        NSLog(@"AdjustFunction: Bridge 'gdprForgetMe' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJaddGlobalCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *key = nil;
        NSString *value = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &value);
        }
        [Adjust addGlobalCallbackParameter:value forKey:key];
    } else {
        NSLog(@"AdjustFunction: Bridge 'addGlobalCallbackParameter' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveGlobalCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *key = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        [Adjust removeGlobalCallbackParameterForKey:key];
    } else {
        NSLog(@"AdjustFunction: Bridge 'removeGlobalCallbackParameter' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveGlobalCallbackParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust removeGlobalCallbackParameters];
    } else {
        NSLog(@"AdjustFunction: Bridge 'removeGlobalCallbackParameters' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJaddGlobalPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *key = nil;
        NSString *value = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &value);
        }
        [Adjust addGlobalPartnerParameter:value forKey:key];
    } else {
        NSLog(@"AdjustFunction: Bridge 'addGlobalPartnerParameter' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveGlobalPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *key = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        [Adjust removeGlobalPartnerParameterForKey:key];
    } else {
        NSLog(@"AdjustFunction: Bridge 'removeGlobalPartnerParameter' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveGlobalPartnerParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust removeGlobalPartnerParameters];
    } else {
        NSLog(@"AdjustFunction: Bridge 'removeGlobalPartnerParameters' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust isEnabledWithCompletionHandler:^(BOOL isEnabled) {
            NSString *strIsEnabled = isEnabled ? @"true" : @"false";
            const char* cResponseData = [strIsEnabled UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_isEnabled",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'isEnabled' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetAdid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust adidWithCompletionHandler:^(NSString * _Nullable adid) {
            NSString *strAdid = adid != nil ? adid : @"ADJ__NULL";
            const char* cResponseData = [strAdid UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getAdid",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getAdid' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetAttribution(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust attributionWithCompletionHandler:^(ADJAttribution * _Nullable attribution) {
            NSString *strAttribution = nil;
            if (attribution == nil) {
                strAttribution = @"ADJ_NULL";
            } else {
                strAttribution =
                [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                 @"trackerToken", attribution.trackerToken,
                 @"trackerName", attribution.trackerName,
                 @"campaign", attribution.campaign,
                 @"network", attribution.network,
                 @"creative", attribution.creative,
                 @"adgroup", attribution.adgroup,
                 @"clickLabel", attribution.clickLabel,
                 @"costType", attribution.costType,
                 @"costAmount", attribution.costAmount == nil ? nil : [attribution.costAmount stringValue],
                 @"costCurrency", attribution.costCurrency];
            }
            const char* cResponseData = [strAttribution UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getAttribution",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getAttribution' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetSdkVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust sdkVersionWithCompletionHandler:^(NSString * _Nullable sdkVersion) {
            NSString *strSdkVersion = sdkVersion != nil ? sdkVersion : @"ADJ__NULL";
            const char* cResponseData = [strSdkVersion UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getSdkVersion",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getSdkVersion' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetLastDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust lastDeeplinkWithCompletionHandler:^(NSURL * _Nullable lastDeeplink) {
            NSString *strLastDeeplink = lastDeeplink != nil ? [lastDeeplink absoluteString] : @"ADJ__NULL";
            const char* cResponseData = [strLastDeeplink UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getLastDeeplink",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getSdkVersion' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

#pragma mark - iOS only methods

FREObject ADJtrackAppStoreSubscription(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 7) {
        NSString *price = nil;
        NSString *currency = nil;
        NSString *transactionId = nil;

        // price [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &price);
        }
        // currency [1]
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &currency);
        }
        // transaction ID [2]
        if (argv[2] != nil) {
            FREGetObjectAsNativeString(argv[2], &transactionId);
        }

        ADJAppStoreSubscription *adjustAppStoreSubscription =
        [[ADJAppStoreSubscription alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:price]
                                              currency:currency
                                         transactionId:transactionId];
        
        // transaction date [3]
        if (argv[3] != nil) {
            NSString *transactionDate = nil;
            FREGetObjectAsNativeString(argv[3], &transactionDate);
            NSTimeInterval transactionDateInterval = [transactionDate doubleValue] / 1000.0;
            NSDate *oTransactionDate = [NSDate dateWithTimeIntervalSince1970:transactionDateInterval];
            [adjustAppStoreSubscription setTransactionDate:oTransactionDate];
        }
        // sales region [4]
        if (argv[4] != nil) {
            NSString *salesRegion = nil;
            FREGetObjectAsNativeString(argv[4], &salesRegion);
            [adjustAppStoreSubscription setSalesRegion:salesRegion];
        }
        // callback parameters [5]
        if (argv[5] != nil) {
            NSMutableArray *callbackParameters = nil;
            FREGetObjectAsNativeArray(argv[5], &callbackParameters);
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustAppStoreSubscription addCallbackParameter:key value:value];
            }
        }
        // partner parameters [6]
        if (argv[6] != nil) {
            NSMutableArray *partnerParameters = nil;
            FREGetObjectAsNativeArray(argv[6], &partnerParameters);
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustAppStoreSubscription addPartnerParameter:key value:value];
            }
        }

        [Adjust trackAppStoreSubscription:adjustAppStoreSubscription];
    } else {
        NSLog(@"AdjustFunction: Bridge 'trackAppStoreSubscription' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJverifyAppStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *productId = nil;
        NSString *transactionId = nil;

        // product ID [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &productId);
        }
        // transaction ID [1]
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &transactionId);
        }

        ADJAppStorePurchase *adjustAppStorePurchase = [[ADJAppStorePurchase alloc] initWithTransactionId:transactionId
                                                                                               productId:productId];
        
        [Adjust verifyAppStorePurchase:adjustAppStorePurchase
                 withCompletionHandler:^(ADJPurchaseVerificationResult * _Nonnull verificationResult) {
            NSString *strVerificationResult = nil;
            if (verificationResult == nil) {
                strVerificationResult = @"ADJ_NULL";
            } else {
                strVerificationResult =
                [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@",
                 @"verificationStatus", verificationResult.verificationStatus,
                 @"message", verificationResult.message,
                 @"code", [NSString stringWithFormat:@"%d", verificationResult.code]];
            }
            const char* cResponseData = [strVerificationResult UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_verifyAppStorePurchase",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'verifyAppStorePurchase' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJverifyAndTrackAppStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 10) {
        NSString *eventToken = nil;

        // event token [0]
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &eventToken);
        }

        ADJEvent *adjustEvent = [[ADJEvent alloc] initWithEventToken:eventToken];

        // revenue [1]
        // currency [2]
        if (argv[2] != nil) {
            NSString *currency = nil;
            FREGetObjectAsNativeString(argv[2], &currency);
            if (argv[1] != nil) {
                double revenue;
                FREGetObjectAsDouble(argv[1], &revenue);
                [adjustEvent setRevenue:revenue currency:currency];
            }
        }
        // callback ID [3]
        if (argv[3] != nil) {
            NSString *callbackId = nil;
            FREGetObjectAsNativeString(argv[3], &callbackId);
            [adjustEvent setCallbackId:callbackId];
        }
        // deduplication ID [4]
        if (argv[4] != nil) {
            NSString *deduplicationId = nil;
            FREGetObjectAsNativeString(argv[4], &deduplicationId);
            [adjustEvent setDeduplicationId:deduplicationId];
        }
        // produt ID [5]
        if (argv[5] != nil) {
            NSString *productId = nil;
            FREGetObjectAsNativeString(argv[5], &productId);
            [adjustEvent setProductId:productId];
        }
        // transaction ID [8]
        if (argv[8] != nil) {
            NSString *transactionId = nil;
            FREGetObjectAsNativeString(argv[8], &transactionId);
            [adjustEvent setTransactionId:transactionId];
        }
        // callback parameters [6]
        if (argv[6] != nil) {
            NSMutableArray *callbackParameters = nil;
            FREGetObjectAsNativeArray(argv[6], &callbackParameters);
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustEvent addCallbackParameter:key value:value];
            }
        }
        // partner parameters [7]
        if (argv[7] != nil) {
            NSMutableArray *partnerParameters = nil;
            FREGetObjectAsNativeArray(argv[7], &partnerParameters);
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];
                if ([key isEqualToString:@"ADJ__NULL"]) {
                    key = nil;
                }
                if ([value isEqualToString:@"ADJ__NULL"]) {
                    value = nil;
                }
                [adjustEvent addPartnerParameter:key value:value];
            }
        }
        
        [Adjust verifyAndTrackAppStorePurchase:adjustEvent
                         withCompletionHandler:^(ADJPurchaseVerificationResult * _Nonnull verificationResult) {
            NSString *strVerificationResult = nil;
            if (verificationResult == nil) {
                strVerificationResult = @"ADJ_NULL";
            } else {
                strVerificationResult =
                [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@",
                 @"verificationStatus", verificationResult.verificationStatus,
                 @"message", verificationResult.message,
                 @"code", [NSString stringWithFormat:@"%d", verificationResult.code]];
            }
            const char* cResponseData = [strVerificationResult UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_verifyAndTrackAppStorePurchase",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'verifyAndTrackAppStorePurchase' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetIdfa(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust idfaWithCompletionHandler:^(NSString * _Nullable idfa) {
            NSString *strIdfa = idfa != nil ? idfa : @"ADJ__NULL";
            const char* cResponseData = [strIdfa UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getIdfa",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getIdfa' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetIdfv(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust idfvWithCompletionHandler:^(NSString * _Nullable idfv) {
            NSString *strIdfv = idfv != nil ? idfv : @"ADJ__NULL";
            const char* cResponseData = [strIdfv UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_getIdfv",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'getIdfv' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetAppTrackingAuthorizationStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        int appTrackingStatus = [Adjust appTrackingAuthorizationStatus];
        NSString *strAppTrackingStatus = [NSString stringWithFormat:@"%d", appTrackingStatus];
        const char* cResponseData = [strAppTrackingStatus UTF8String];
        FREDispatchStatusEventAsync(ctx,
                (const uint8_t *)"adjust_getAppTrackingAuthorizationStatus",
                (const uint8_t *)cResponseData);
    } else {
        NSLog(@"AdjustFunction: Bridge 'getAppTrackingAuthorizationStatus' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJrequestAppTrackingAuthorization(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust requestAppTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            NSString *strAppTrackingStatus = [NSString stringWithFormat:@"%lu", status];
            const char* cResponseData = [strAppTrackingStatus UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_requestAppTrackingAuthorization",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'requestAppTrackingAuthorization' method triggered with wrong number of arguments");
    }
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJupdateSkanConversionValue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 3) {
        int conversionValue = -1;
        FREGetObjectAsInt32(argv[0], &conversionValue);
        NSString *coarseValue = nil;
        FREGetObjectAsNativeString(argv[1], &coarseValue);
        BOOL lockWindow;
        FREGetObjectAsNativeBool(argv[2], &lockWindow);

        [Adjust updateSkanConversionValue:conversionValue
                              coarseValue:coarseValue
                               lockWindow:[NSNumber numberWithBool:lockWindow]
                    withCompletionHandler:^(NSError * _Nullable error) {
            NSString *response = @"ADJ__NULL";
            if (nil != error) {
                response = [error localizedDescription];
            }
            const char* cResponseData = [response UTF8String];
            FREDispatchStatusEventAsync(ctx,
                    (const uint8_t *)"adjust_updateSkanConversionValue",
                    (const uint8_t *)cResponseData);
        }];
    } else {
        NSLog(@"AdjustFunction: Bridge 'updateSkanConversionValue' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

#pragma mark - Android only methods

FREObject ADJtrackPlayStoreSubscription(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJverifyPlayStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSString *verificationResult = @"ADJ__NULL";
    const char* cResponseData = [verificationResult UTF8String];
    FREDispatchStatusEventAsync(ctx,
            (const uint8_t *)"adjust_verifyPlayStorePurchase",
            (const uint8_t *)cResponseData);

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJverifyAndTrackPlayStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSString *verificationResult = @"ADJ__NULL";
    const char* cResponseData = [verificationResult UTF8String];
    FREDispatchStatusEventAsync(ctx,
            (const uint8_t *)"adjust_verifyAndTrackPlayStorePurchase",
            (const uint8_t *)cResponseData);

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetGoogleAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSString *googleAdId = @"ADJ__NULL";
    const char* cResponseData = [googleAdId UTF8String];
    FREDispatchStatusEventAsync(ctx,
            (const uint8_t *)"adjust_getGoogleAdId",
            (const uint8_t *)cResponseData);

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetAmazonAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSString *amazonAdId = @"ADJ__NULL";
    const char* cResponseData = [amazonAdId UTF8String];
    FREDispatchStatusEventAsync(ctx,
            (const uint8_t *)"adjust_getAmazonAdId",
            (const uint8_t *)cResponseData);

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

#pragma mark - Testing only methods

FREObject ADJonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [Adjust trackSubsessionStart];
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [Adjust trackSubsessionEnd];
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetTestOptions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 13) {
        NSMutableDictionary *testOptions = [NSMutableDictionary dictionary];

        // URL overwrite [0]
        if (argv[0] != nil) {
            NSString *urlOverwrite = nil;
            FREGetObjectAsNativeString(argv[0], &urlOverwrite);
            [testOptions setObject:urlOverwrite forKey:@"testUrlOverwrite"];
        }
        // extra path [1]
        if (argv[1] != nil) {
            NSString *extraPath = nil;
            FREGetObjectAsNativeString(argv[1], &extraPath);
            [testOptions setObject:extraPath forKey:@"extraPath"];
        }
        // timer interval [2]
        if (argv[2] != nil) {
            NSString *timerIntervalInMilliseconds = nil;
            FREGetObjectAsNativeString(argv[2], &timerIntervalInMilliseconds);
            [testOptions setObject:convertMilliStringToNumber(timerIntervalInMilliseconds)
                            forKey:@"timerIntervalInMilliseconds"];
        }
        // timer start [3]
        if (argv[3] != nil) {
            NSString *timerStartInMilliseconds = nil;
            FREGetObjectAsNativeString(argv[3], &timerStartInMilliseconds);
            [testOptions setObject:convertMilliStringToNumber(timerStartInMilliseconds)
                            forKey:@"timerStartInMilliseconds"];
        }
        // session interval [4]
        if (argv[4] != nil) {
            NSString *sessionIntervalInMilliseconds = nil;
            FREGetObjectAsNativeString(argv[4], &sessionIntervalInMilliseconds);
            [testOptions setObject:convertMilliStringToNumber(sessionIntervalInMilliseconds)
                            forKey:@"sessionIntervalInMilliseconds"];
        }
        // subsession interval [5]
        if (argv[5] != nil) {
            NSString *subsessionIntervalInMilliseconds = nil;
            FREGetObjectAsNativeString(argv[5], &subsessionIntervalInMilliseconds);
            [testOptions setObject:convertMilliStringToNumber(subsessionIntervalInMilliseconds)
                            forKey:@"subsessionIntervalInMilliseconds"];
        }
        // ATT status [6]
        if (argv[6] != nil) {
            NSString *attStatus = nil;
            FREGetObjectAsNativeString(argv[6], &attStatus);
            [testOptions setObject:attStatus forKey:@"attStatusInt"];
        }
        // IDFA [7]
        if (argv[7] != nil) {
            NSString *idfa = nil;
            FREGetObjectAsNativeString(argv[7], &idfa);
            [testOptions setObject:idfa forKey:@"idfa"];
        }
        // no backoff wait [8]
        if (argv[8] != nil) {
            BOOL noBackoffWait;
            FREGetObjectAsNativeBool(argv[8], &noBackoffWait);
            [testOptions setObject:@(noBackoffWait) forKey:@"noBackoffWait"];
        }
        // AdServices.framework enabled [9]
        if (argv[9] != nil) {
            BOOL isAdServicesFrameworkEnabled;
            FREGetObjectAsNativeBool(argv[9], &isAdServicesFrameworkEnabled);
            [testOptions setObject:@(isAdServicesFrameworkEnabled)
                            forKey:@"adServicesFrameworkEnabled"];
        }
        // teardown [10]
        if (argv[10] != nil) {
            BOOL teardown;
            FREGetObjectAsNativeBool(argv[10], &teardown);
            [testOptions setObject:@(teardown) forKey:@"teardown"];
        }
        // delete state [11]
        if (argv[11] != nil) {
            BOOL deleteState;
            FREGetObjectAsNativeBool(argv[11], &deleteState);
            [testOptions setObject:@(deleteState) forKey:@"deleteState"];
        }

        [Adjust setTestOptions:testOptions];
    } else {
        NSLog(@"AdjustFunction: Bridge 'setTestOptions' method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJteardown(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [AdjustSdkDelegate teardown];
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

#pragma mark - Utility methods

NSNumber *convertMilliStringToNumber(NSString *strMilliseconds) {
    NSNumber *numberMilliseconds = [NSNumber numberWithInt:[strMilliseconds intValue]];
    return numberMilliseconds;
}
