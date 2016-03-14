//
//  AdjustFunction.m
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustFunction.h"
#import "AdjustFREUtils.h"

FREContext adjustFREContext;

@implementation AdjustFunction

static id<AdjustDelegate> adjustFunctionInstance = nil;

- (id) init {
    self = [super init];
    return self;
}

- (void)adjustAttributionChanged:(ADJAttribution *)attribution {
    NSString *attributionString = [NSString stringWithFormat:@"%@=%@,%@=%@,%@=%@,%@=%@,%@=%@,%@=%@,%@=%@",
                                   @"trackerToken", attribution.trackerToken,
                                   @"trackerName", attribution.trackerName,
                                   @"campaign", attribution.campaign,
                                   @"network", attribution.network,
                                   @"creative", attribution.creative,
                                   @"adgroup", attribution.adgroup,
                                   @"clickLabel", attribution.clickLabel];
    const char* cResponseData = [attributionString UTF8String];

    FREDispatchStatusEventAsync(adjustFREContext,
                                (const uint8_t *)"adjust_attributionData",
                                (const uint8_t *)cResponseData);
}

@end

FREObject ADJonCreate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 7) {
        NSString *appToken = nil;
        NSString *environment = nil;
        NSString *logLevel = nil;
        NSString *defaultTracker = nil;
        NSString *sdkPrefix = nil;

        BOOL eventBufferingEnabled;
        BOOL isAttributionCallbackSet;

        adjustFREContext = ctx;

        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &appToken);
        }

        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &environment);
        }

        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken environment:environment];

        if (argv[2] != nil) {
            FREGetObjectAsNativeString(argv[2], &logLevel);

            if (logLevel != nil) {
                [adjustConfig setLogLevel:[ADJLogger LogLevelFromString:logLevel]];
            }
        }

        if (argv[3] != nil) {
            FREGetObjectAsNativeBool(argv[3], &eventBufferingEnabled);
            [adjustConfig setEventBufferingEnabled:eventBufferingEnabled];
        }

        if (argv[4] != nil) {
            FREGetObjectAsNativeBool(argv[4], &isAttributionCallbackSet);

            if (isAttributionCallbackSet) {
                if (adjustFunctionInstance == nil) {
                    adjustFunctionInstance = [[AdjustFunction alloc] init];
                }

                [adjustConfig setDelegate:(id)adjustFunctionInstance];
            }
        }

        if (argv[5] != nil) {
            FREGetObjectAsNativeString(argv[5], &defaultTracker);

            if (defaultTracker != nil) {
                [adjustConfig setDefaultTracker:defaultTracker];
            }
        }

        if (argv[6] != nil) {
            FREGetObjectAsNativeString(argv[7], &sdkPrefix);
            [adjustConfig setSdkPrefix:sdkPrefix];
        }

        [Adjust appDidLaunch:adjustConfig];
    } else {
        NSLog(@"Adjust: Bridge onCreate method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJtrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 8) {
        double revenue;

        BOOL isReceiptSet;

        NSString *eventToken = nil;
        NSString *currency = nil;
        NSString *receipt = nil;
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
            }

            [adjustEvent setRevenue:revenue currency:currency];
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

        if (argv[7] != nil) {
            FREGetObjectAsNativeBool(argv[7], &isReceiptSet);

            if (argv[6] != nil) {
                FREGetObjectAsNativeString(argv[6], &receipt);
            }

            if (argv[7] != nil) {
                FREGetObjectAsNativeString(argv[5], &transactionId);
            }

            if (isReceiptSet) {
                [adjustEvent setReceipt:[receipt dataUsingEncoding:NSUTF8StringEncoding] transactionId:transactionId];
            } else {
                if (transactionId != nil) {
                    [adjustEvent setTransactionId:transactionId];
                }
            }
        }

        [Adjust trackEvent:adjustEvent];
    } else {
        NSLog(@"Adjust: Bridge trackEvent method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJsetEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        BOOL enable;

        FREGetObjectAsNativeBool(argv[0], &enable);

        [Adjust setEnabled:enable];
    } else {
        NSLog(@"Adjust: Bridge setEnabled method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        BOOL isEnabled = [Adjust isEnabled];

        FREObject return_value;
        FRENewObjectFromBool((uint32_t)isEnabled, &return_value);

        return return_value;
    } else {
        NSLog(@"Adjust: Bridge isEnabled method triggered with wrong number of arguments");

        FREObject return_value;
        FRENewObjectFromBool(false, &return_value);

        return return_value;
    }
}

FREObject ADJonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)ADJisEnabled, &return_value);

    return return_value;
}

FREObject ADJonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)ADJisEnabled, &return_value);

    return return_value;
}

FREObject ADJappWillOpenUrl(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *pUrl;

        FREGetObjectAsNativeString(argv[0], &pUrl);

        NSURL *url = [NSURL URLWithString:pUrl];

        [Adjust appWillOpenUrl:url];
    } else {
        NSLog(@"Adjust: Bridge appWillOpenUrl method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJsetOfflineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        BOOL isOffline;

        FREGetObjectAsNativeBool(argv[0], &isOffline);

        [Adjust setOfflineMode:isOffline];
    } else {
        NSLog(@"Adjust: Bridge setOfflineMode method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJsetDeviceToken(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *pDeviceToken;

        FREGetObjectAsNativeString(argv[0], &pDeviceToken);

        NSData *deviceToken = [pDeviceToken dataUsingEncoding:NSUTF8StringEncoding];

        [Adjust setDeviceToken:deviceToken];
    } else {
        NSLog(@"Adjust: Bridge setDeviceToken method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}

FREObject ADJgetIdfa(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 0) {
        NSString *idfa = [Adjust idfa];

        FREObject return_value;
        FRENewObjectFromUTF8((uint32_t)[idfa length], (const uint8_t *)[idfa UTF8String], &return_value);

        return return_value;
    } else {
        NSLog(@"Adjust: Bridge isEnabled method triggered with wrong number of arguments");

        return NULL;
    }
}

FREObject ADJsetReferrer(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    
    return return_value;
}

FREObject ADJgetGoogleAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}
