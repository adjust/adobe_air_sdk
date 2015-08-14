//
//  AdjustFunction.m
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustFunction.h"
#import "AdjustFREUtils.h"

FREContext AdjustFREContext;

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

    NSLog(@"Sazdah enesstring = %@", attributionString);

    FREDispatchStatusEventAsync(AdjustFREContext,
                                (const uint8_t *)"adjust_attributionData",
                                (const uint8_t *)cResponseData);
}

@end

FREObject AIonCreate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *appToken;
    NSString *environment;
    NSString *logLevel;
    BOOL eventBufferingEnabled;

    AdjustFREContext = ctx;

    FREGetObjectAsNativeString(argv[0], &appToken);
    FREGetObjectAsNativeString(argv[1], &environment);
    FREGetObjectAsNativeString(argv[2], &logLevel);

    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken environment:ADJEnvironmentSandbox];
    [adjustConfig setLogLevel:[ADJLogger LogLevelFromString:logLevel]];

    if (argv[3] != nil) {
        FREGetObjectAsNativeBool(argv[3], &eventBufferingEnabled);
        [adjustConfig setEventBufferingEnabled:eventBufferingEnabled];
    }

    [adjustConfig setSdkPrefix:@"adobe_air4.0.0"];

    if (adjustFunctionInstance == nil) {
        adjustFunctionInstance = [[AdjustFunction alloc] init];
    }
    [adjustConfig setDelegate:(id)adjustFunctionInstance];

    [Adjust appDidLaunch:adjustConfig];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject AItrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *eventToken;
    NSString *currency;
    double revenue;
    NSMutableArray *callbackParameters;
    NSMutableArray *partnerParameters;

    FREGetObjectAsNativeString(argv[0], &eventToken);
    FREGetObjectAsNativeString(argv[1], &currency);
    FREGetObjectAsDouble(argv[2], &revenue);
    FREGetObjectAsNativeArray(argv[3], &callbackParameters);
    FREGetObjectAsNativeArray(argv[4], &partnerParameters);

    if (eventToken != nil) {
        ADJEvent *adjustEvent = [ADJEvent eventWithEventToken:eventToken];

        if (currency != nil) {
            [adjustEvent setRevenue:revenue currency:currency];
        }

        if (callbackParameters != nil) {
            for (int i = 0; i < [callbackParameters count]; i += 2) {
                NSString *key = [callbackParameters objectAtIndex:i];
                NSString *value = [callbackParameters objectAtIndex:(i+1)];

                [adjustEvent addCallbackParameter:key value:value];
            }
        }

        if (partnerParameters != nil) {
            for (int i = 0; i < [partnerParameters count]; i += 2) {
                NSString *key = [partnerParameters objectAtIndex:i];
                NSString *value = [partnerParameters objectAtIndex:(i+1)];

                [adjustEvent addPartnerParameter:key value:value];
            }
        }

        [Adjust trackEvent:adjustEvent];
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject AIsetEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    BOOL enable;

    FREGetObjectAsNativeBool(argv[0], &enable);

    [Adjust setEnabled:enable];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject AIisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    BOOL isEnabled = [Adjust isEnabled];

    FREObject return_value;
    FRENewObjectFromBool((uint32_t)isEnabled, &return_value);
    return return_value;
}

FREObject AIonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)AIisEnabled, &return_value);
    return return_value;
}

FREObject AIonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)AIisEnabled, &return_value);
    return return_value;
}
