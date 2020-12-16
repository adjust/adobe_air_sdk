//
//  AdjustFunction.m
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

#import "AdjustFunction.h"
#import "AdjustFREUtils.h"
#import "AdjustSdkDelegate.h"

FREContext adjustFREContext;
BOOL shouldLaunchDeferredDeeplink;

@implementation AdjustFunction

@end

FREObject ADJonCreate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 31) {
        NSString *appToken = nil;
        NSString *environment = nil;
        NSString *logLevelString = nil;
        NSString *defaultTracker = nil;
        NSString *externalDeviceId = nil;
        NSString *sdkPrefix = nil;
        NSString *secretId = nil;
        NSString *info1 = nil;
        NSString *info2 = nil;
        NSString *info3 = nil;
        NSString *info4 = nil;
        BOOL eventBufferingEnabled = NO;
        BOOL isAttributionCallbackImplemented = NO;
        BOOL isEventTrackingSucceededCallbackImplemented = NO;
        BOOL isEventTrackingFailedCallbackImplemented = NO;
        BOOL isSessionTrackingSucceededCallbackImplemented = NO;
        BOOL isSessionTrackingFailedCallbackImplemented = NO;
        BOOL isDeferredDeeplinkCallbackImplemented = NO;
        BOOL allowSuppressLogLevel = NO;

        adjustFREContext = ctx;

        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &appToken);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &environment);
        }
        if (argv[2] != nil) {
            FREGetObjectAsNativeString(argv[2], &logLevelString);
            if (logLevelString != nil) {
                if ([logLevelString isEqualToString:@"suppress"]) {
                    allowSuppressLogLevel = YES;
                }
            }
        }

        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken environment:environment allowSuppressLogLevel:allowSuppressLogLevel];

        if (logLevelString != nil) {
            [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[logLevelString lowercaseString]]];
        }
        if (argv[3] != nil) {
            FREGetObjectAsNativeBool(argv[3], &eventBufferingEnabled);
            [adjustConfig setEventBufferingEnabled:eventBufferingEnabled];
        }
        if (argv[4] != nil) {
            FREGetObjectAsNativeBool(argv[4], &isAttributionCallbackImplemented);
        }
        if (argv[5] != nil) {
            FREGetObjectAsNativeBool(argv[5], &isEventTrackingSucceededCallbackImplemented);
        }
        if (argv[6] != nil) {
            FREGetObjectAsNativeBool(argv[6], &isEventTrackingFailedCallbackImplemented);
        }
        if (argv[7] != nil) {
            FREGetObjectAsNativeBool(argv[7], &isSessionTrackingSucceededCallbackImplemented);
        }
        if (argv[8] != nil) {
            FREGetObjectAsNativeBool(argv[8], &isSessionTrackingFailedCallbackImplemented);
        }
        if (argv[9] != nil) {
            FREGetObjectAsNativeBool(argv[9], &isDeferredDeeplinkCallbackImplemented);
        }
        if (argv[10] != nil) {
            FREGetObjectAsNativeString(argv[10], &defaultTracker);

            if (defaultTracker != nil) {
                [adjustConfig setDefaultTracker:defaultTracker];
            }
        }
        if (argv[11] != nil) {
            FREGetObjectAsNativeString(argv[11], &sdkPrefix);
            [adjustConfig setSdkPrefix:sdkPrefix];
        }
        if (argv[12] != nil) {
            FREGetObjectAsNativeBool(argv[12], &shouldLaunchDeferredDeeplink);
        }
        if (isAttributionCallbackImplemented
            || isEventTrackingSucceededCallbackImplemented
            || isEventTrackingFailedCallbackImplemented
            || isSessionTrackingSucceededCallbackImplemented
            || isSessionTrackingFailedCallbackImplemented
            || isDeferredDeeplinkCallbackImplemented) {
            [adjustConfig setDelegate:
             [AdjustSdkDelegate getInstanceWithSwizzleOfAttributionCallback:isAttributionCallbackImplemented
                                                     eventSucceededCallback:isEventTrackingSucceededCallbackImplemented
                                                        eventFailedCallback:isEventTrackingFailedCallbackImplemented
                                                   sessionSucceededCallback:isSessionTrackingSucceededCallbackImplemented
                                                      sessionFailedCallback:isSessionTrackingFailedCallbackImplemented
                                                   deferredDeeplinkCallback:isDeferredDeeplinkCallbackImplemented
                                               shouldLaunchDeferredDeeplink:shouldLaunchDeferredDeeplink
                                                                 withFREContext:&adjustFREContext]];
        }

        // arg 13 is for Android only: processName

        if (argv[14] != nil) {
            double delayStart;
            FREGetObjectAsDouble(argv[14], &delayStart);
            [adjustConfig setDelayStart:delayStart];
        }
        if (argv[15] != nil) {
            NSString *userAgent = nil;
            FREGetObjectAsNativeString(argv[15], &userAgent);
            [adjustConfig setUserAgent:userAgent];
        }
        if (argv[16] != nil) {
            BOOL sendInBackground = NO;
            FREGetObjectAsNativeBool(argv[16], &sendInBackground);
            [adjustConfig setSendInBackground:sendInBackground];
        }
        if (argv[17] != nil) {
            FREGetObjectAsNativeString(argv[17], &secretId);
        }
        if (argv[18] != nil) {
            FREGetObjectAsNativeString(argv[18], &info1);
        }
        if (argv[19] != nil) {
            FREGetObjectAsNativeString(argv[19], &info2);
        }
        if (argv[20] != nil) {
            FREGetObjectAsNativeString(argv[20], &info3);
        }
        if (argv[21] != nil) {
            FREGetObjectAsNativeString(argv[21], &info4);
        }
        if (argv[22] != nil) {
            BOOL isDeviceKnown = NO;
            FREGetObjectAsNativeBool(argv[22], &isDeviceKnown);
            [adjustConfig setIsDeviceKnown:isDeviceKnown];
        }

        // arg 23 is for Android only: readMobileEquipmentIdentity

        if (argv[24] != nil) {
            FREGetObjectAsNativeString(argv[24], &externalDeviceId);

            if (externalDeviceId != nil) {
                [adjustConfig setExternalDeviceId:externalDeviceId];
            }
        }
        if (argv[25] != nil) {
            BOOL allowiAdInfoReading = YES;
            FREGetObjectAsNativeBool(argv[25], &allowiAdInfoReading);
            [adjustConfig setAllowiAdInfoReading:allowiAdInfoReading];
        }
        if (argv[26] != nil) {
            BOOL allowIdfaReading = YES;
            FREGetObjectAsNativeBool(argv[26], &allowIdfaReading);
            [adjustConfig setAllowIdfaReading:allowIdfaReading];
        }
        if (argv[27] != nil) {
            NSString *urlStrategy = nil;
            FREGetObjectAsNativeString(argv[27], &urlStrategy);
            if ([urlStrategy isEqualToString:@"china"]) {
                [adjustConfig setUrlStrategy:ADJUrlStrategyChina];
            } else if ([urlStrategy isEqualToString:@"india"]) {
                [adjustConfig setUrlStrategy:ADJUrlStrategyIndia];
            }
        }
        if (argv[28] != nil) {
            BOOL needsCost = NO;
            FREGetObjectAsNativeBool(argv[28], &needsCost);
            if (YES == needsCost) {
                [adjustConfig setNeedsCost:YES];
            }
        }
        if (argv[29] != nil) {
            BOOL skAdNetworkHandling = YES;
            FREGetObjectAsNativeBool(argv[29], &skAdNetworkHandling);
            if (NO == skAdNetworkHandling) {
                [adjustConfig deactivateSKAdNetworkHandling];
            }
        }
        
        // argv[30] is for Android only: preinstallTrackingEnabled

        if (secretId != nil && info1 != nil && info2 != nil && info3 != nil && info4 != nil) {
            NSUInteger uiSecretId = [[NSNumber numberWithLongLong:[secretId longLongValue]] unsignedIntegerValue];
            NSUInteger uiInfo1 = [[NSNumber numberWithLongLong:[info1 longLongValue]] unsignedIntegerValue];
            NSUInteger uiInfo2 = [[NSNumber numberWithLongLong:[info2 longLongValue]] unsignedIntegerValue];
            NSUInteger uiInfo3 = [[NSNumber numberWithLongLong:[info3 longLongValue]] unsignedIntegerValue];
            NSUInteger uiInfo4 = [[NSNumber numberWithLongLong:[info4 longLongValue]] unsignedIntegerValue];
            if (uiSecretId > 0 && uiInfo1 > 0 && uiInfo2 > 0 && uiInfo3 > 0 && uiInfo4 > 0) {
                [adjustConfig setAppSecret:uiSecretId info1:uiInfo1 info2:uiInfo2 info3:uiInfo3 info4:uiInfo4];
            }
        }

        [Adjust appDidLaunch:adjustConfig];
        [Adjust trackSubsessionStart];
    } else {
        NSLog(@"AdjustFunction: Bridge onCreate method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 9) {
        double revenue;
        // BOOL isReceiptSet;
        NSString *eventToken = nil;
        NSString *currency = nil;
        // NSString *receipt = nil;
        NSString *callbackId = nil;
        NSString *transactionId = nil;
        NSMutableArray *callbackParameters = nil;
        NSMutableArray *partnerParameters = nil;

        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &eventToken);
        }

        ADJEvent *adjustEvent = [ADJEvent eventWithEventToken:eventToken];

        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &currency);
            if (argv[2] != nil) {
                FREGetObjectAsDouble(argv[2], &revenue);
                [adjustEvent setRevenue:revenue currency:currency];
            }
        }
        if (argv[3] != nil) {
            FREGetObjectAsNativeArray(argv[3], &callbackParameters);
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];
                [adjustEvent addCallbackParameter:key value:value];
            }
        }
        if (argv[4] != nil) {
            FREGetObjectAsNativeArray(argv[4], &partnerParameters);
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];
                [adjustEvent addPartnerParameter:key value:value];
            }
        }
        if (argv[5] != nil) {
            FREGetObjectAsNativeString(argv[5], &callbackId);
            if (callbackId != nil) {
                [adjustEvent setCallbackId:callbackId];
            }
        }
        if (argv[6] != nil) {
            FREGetObjectAsNativeString(argv[6], &transactionId);
            if (transactionId != nil) {
                [adjustEvent setTransactionId:transactionId];
            }
        }
        
        // Deprecated.
        // if (argv[8] != nil) {
        //     FREGetObjectAsNativeBool(argv[8], &isReceiptSet);
        //     if (argv[7] != nil) {
        //         FREGetObjectAsNativeString(argv[7], &receipt);
        //     }
        //     if (argv[6] != nil) {
        //         FREGetObjectAsNativeString(argv[6], &transactionId);
        //     }
        //     if (isReceiptSet) {
        //         [adjustEvent setReceipt:[receipt dataUsingEncoding:NSUTF8StringEncoding] transactionId:transactionId];
        //     } else {
        //         if (transactionId != nil) {
        //             [adjustEvent setTransactionId:transactionId];
        //         }
        //     }
        // }

        [Adjust trackEvent:adjustEvent];
    } else {
        NSLog(@"AdjustFunction: Bridge trackEvent method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        BOOL enable;
        FREGetObjectAsNativeBool(argv[0], &enable);
        [Adjust setEnabled:enable];
    } else {
        NSLog(@"AdjustFunction: Bridge setEnabled method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        BOOL isEnabled = [Adjust isEnabled];
        FREObject returnValue;
        FRENewObjectFromBool((uint32_t)isEnabled, &returnValue);
        return returnValue;
    } else {
        NSLog(@"AdjustFunction: Bridge isEnabled method triggered with wrong number of arguments");
        FREObject returnValue;
        FRENewObjectFromBool(false, &returnValue);
        return returnValue;
    }
}

FREObject ADJonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [Adjust trackSubsessionStart];
    FREObject returnValue;
    FRENewObjectFromBool((uint32_t)ADJisEnabled, &returnValue);
    return returnValue;
}

FREObject ADJonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [Adjust trackSubsessionEnd];
    FREObject returnValue;
    FRENewObjectFromBool((uint32_t)ADJisEnabled, &returnValue);
    return returnValue;
}

FREObject ADJappWillOpenUrl(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *pUrl;
        FREGetObjectAsNativeString(argv[0], &pUrl);
        NSURL *url = [NSURL URLWithString:pUrl];
        [Adjust appWillOpenUrl:url];
    } else {
        NSLog(@"AdjustFunction: Bridge appWillOpenUrl method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetOfflineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        BOOL isOffline;
        FREGetObjectAsNativeBool(argv[0], &isOffline);
        [Adjust setOfflineMode:isOffline];
    } else {
        NSLog(@"AdjustFunction: Bridge setOfflineMode method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetDeviceToken(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *pDeviceToken;
        FREGetObjectAsNativeString(argv[0], &pDeviceToken);
        [Adjust setPushToken:pDeviceToken];
    } else {
        NSLog(@"AdjustFunction: Bridge setDeviceToken method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetIdfa(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        NSString *idfa = [Adjust idfa];
        FREObject returnValue;
        FRENewObjectFromUTF8((uint32_t)[idfa length], (const uint8_t *)[idfa UTF8String], &returnValue);
        return returnValue;
    } else {
        NSLog(@"AdjustFunction: Bridge getIdfa method triggered with wrong number of arguments");
        return NULL;
    }
}

FREObject ADJgetAdid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        NSString *adid = [Adjust adid];
        if (adid == nil) {
            return NULL;
        }
        FREObject returnValue;
        FRENewObjectFromUTF8((uint32_t)[adid length], (const uint8_t *)[adid UTF8String], &returnValue);
        return returnValue;
    } else {
        NSLog(@"AdjustFunction: Bridge getAdid method triggered with wrong number of arguments");
        return NULL;
    }
}

FREObject ADJgetAttribution(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        ADJAttribution *attribution = [Adjust attribution];
        if (attribution == nil) {
            return NULL;
        }

        NSString *attributionString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                       @"trackerToken", attribution.trackerToken,
                                       @"trackerName", attribution.trackerName,
                                       @"campaign", attribution.campaign,
                                       @"network", attribution.network,
                                       @"creative", attribution.creative,
                                       @"adgroup", attribution.adgroup,
                                       @"clickLabel", attribution.clickLabel,
                                       @"adid", attribution.adid,
                                       @"costType", attribution.costType,
                                       @"costAmount", attribution.costAmount == nil ? nil : [attribution.costAmount stringValue],
                                       @"costCurrency", attribution.costCurrency];
        FREObject returnValue;
        FRENewObjectFromUTF8((uint32_t)[attributionString length], (const uint8_t *)[attributionString UTF8String], &returnValue);
        return returnValue;
    } else {
        NSLog(@"AdjustFunction: Bridge getAttribution method triggered with wrong number of arguments");
        return NULL;
    }
}

FREObject ADJgetSdkVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        NSString *sdkVersion = [Adjust sdkVersion];
        if (sdkVersion == nil) {
            return NULL;
        }
        FREObject returnValue;
        FRENewObjectFromUTF8((uint32_t)[sdkVersion length], (const uint8_t *)[sdkVersion UTF8String], &returnValue);
        return returnValue;
    } else {
        NSLog(@"AdjustFunction: Bridge getSdkVersion method triggered with wrong number of arguments");
        return NULL;
    }
}

FREObject ADJsetReferrer(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetGoogleAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgetAmazonAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJaddSessionCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *key = nil;
        NSString *value = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &value);
        }
        [Adjust addSessionCallbackParameter:key value:value];
    } else {
        NSLog(@"AdjustFunction: Bridge addSessionCallbackParameter method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveSessionCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *key = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        [Adjust removeSessionCallbackParameter:key];
    } else {
        NSLog(@"AdjustFunction: Bridge removeSessionCallbackParameter method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJresetSessionCallbackParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust resetSessionCallbackParameters];
    } else {
        NSLog(@"AdjustFunction: Bridge resetSessionCallbackParameters method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJaddSessionPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *key = nil;
        NSString *value = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &value);
        }
        [Adjust addSessionPartnerParameter:key value:value];
    } else {
        NSLog(@"AdjustFunction: Bridge addSessionPartnerParameter method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJremoveSessionPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *key = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        [Adjust removeSessionPartnerParameter:key];
    } else {
        NSLog(@"AdjustFunction: Bridge removeSessionPartnerParameter method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJresetSessionPartnerParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust resetSessionPartnerParameters];
    } else {
        NSLog(@"AdjustFunction: Bridge resetSessionPartnerParameters method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsendFirstPackages(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust sendFirstPackages];
    } else {
        NSLog(@"AdjustFunction: Bridge sendFirstPackages method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJgdprForgetMe(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust gdprForgetMe];
    } else {
        NSLog(@"AdjustFunction: Bridge gdprForgetMe method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJdisableThirdPartySharing(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        [Adjust disableThirdPartySharing];
    } else {
        NSLog(@"AdjustFunction: Bridge disableThirdPartySharing method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJtrackAdRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *source = nil;
        NSString *payload = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &source);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &payload);
        }
        NSData *dataPayload = [payload dataUsingEncoding:NSUTF8StringEncoding];
        [Adjust trackAdRevenue:source payload:dataPayload];
    } else {
        NSLog(@"AdjustFunction: Bridge trackAdRevenue method triggered with wrong number of arguments");
    }

    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJrequestTrackingAuthorizationWithCompletionHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [Adjust requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
        NSString *formattedString = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%zd", status]];
        const char* cResponseData = [formattedString UTF8String];
        FREDispatchStatusEventAsync(ctx,
                (const uint8_t *)"adjust_authorizationStatus",
                (const uint8_t *)cResponseData);
    }];
    
    FREObject returnValue;
    FRENewObjectFromBool(true, &returnValue);
    return returnValue;
}

FREObject ADJsetTestOptions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 14) {
        AdjustTestOptions * testOptions = [[AdjustTestOptions alloc] init];

        // Treating Android's `hasContext` as `deleteState`
        if (argv[0] != nil) {
            BOOL value;
            FREGetObjectAsNativeBool(argv[0], &value);
            testOptions.deleteState = value;
        }
        if (argv[1] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[1], &value);
            testOptions.baseUrl = value;
        }
        // TODO: double check value of argv[2]
        if (argv[2] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[2], &value);
            testOptions.extraPath = value;
        }
        if (argv[3] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[3], &value);
            testOptions.gdprUrl = value;
        }
        // TODO: double check value of argv[4]
        // if (argv[4] != nil) {
        //     NSString *value;
        //     FREGetObjectAsNativeString(argv[4], &value);
        //     testOptions.gdprPath = value;
        // }

        // Skipping 5th argument

        if (argv[6] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[6], &value);
            testOptions.timerIntervalInMilliseconds = convertMilliStringToNumber(value);
        }
        if (argv[7] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[7], &value);
            testOptions.timerStartInMilliseconds = convertMilliStringToNumber(value);
        }
        if (argv[8] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[8], &value);
            testOptions.sessionIntervalInMilliseconds = convertMilliStringToNumber(value);
        }
        if (argv[9] != nil) {
            NSString *value;
            FREGetObjectAsNativeString(argv[9], &value);
            testOptions.subsessionIntervalInMilliseconds = convertMilliStringToNumber(value);
        }
        if (argv[10] != nil) {
            BOOL value;
            FREGetObjectAsNativeBool(argv[10], &value);
            testOptions.teardown = value;
        }

        // Skipping 12th argument

        if (argv[12] != nil) {
            BOOL value;
            FREGetObjectAsNativeBool(argv[12], &value);
            testOptions.noBackoffWait = value;
        }
        if (argv[13] != nil) {
            BOOL value;
            FREGetObjectAsNativeBool(argv[13], &value);
            testOptions.iAdFrameworkEnabled = value;
        }

        [Adjust setTestOptions:testOptions];
    } else {
        NSLog(@"AdjustFunction: Bridge setTestOptions method triggered with wrong number of arguments");
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

NSNumber *convertMilliStringToNumber(NSString *milliS) {
    NSNumber *number = [NSNumber numberWithInt:[milliS intValue]];
    return number;
}
