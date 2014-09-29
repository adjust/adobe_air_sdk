//
//  AdjustFunction.m
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustFunction.h"
#import "AdjustFREUtils.h"
#import "AILogger.h"

FREContext AdjustFREContext;

@implementation AdjustFunction

static id<AdjustDelegate> AdjustFunctionInstance = nil;

- (id) init {
    self = [super init];
    return self;
}

- (void)adjustFinishedTrackingWithResponse:(AIResponseData *)responseData {
    NSDictionary *dicResponseData = [responseData dictionary];
    NSData *dResponseData = [NSJSONSerialization dataWithJSONObject:dicResponseData options:0 error:nil];
    NSString *sResponseData = [[NSString alloc] initWithBytes:[dResponseData bytes]
                                                       length:[dResponseData length]
                                                     encoding:NSUTF8StringEncoding];
    const char * cResponseData= [sResponseData UTF8String];
    
    FREDispatchStatusEventAsync(AdjustFREContext,
                                (const uint8_t *)"adjust_responseData",
                                (const uint8_t *)cResponseData);
}

@end

FREObject appDidLaunch(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *appToken;
    NSString *envirnoment;
    NSString *logLevel;
    BOOL eventBufferingEnabled;
    NSString *sdkVersion;

    FREGetObjectAsNativeString(argv[0], &appToken);
    FREGetObjectAsNativeString(argv[1], &envirnoment);
    FREGetObjectAsNativeString(argv[2], &logLevel);
    FREGetObjectAsNativeBool(argv[3], &eventBufferingEnabled);
    FREGetObjectAsNativeString(argv[4], &sdkVersion);

    [Adjust appDidLaunch:appToken];
    [Adjust setEnvironment:envirnoment];
    [Adjust setLogLevel:[AILogger LogLevelFromString:logLevel]];
    [Adjust setSdkPrefix:sdkVersion];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject trackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *eventToken;
    NSDictionary *parameters;

    FREGetObjectAsNativeString(argv[0], &eventToken);
    FREGetObjectAsNativeDictionary(argv[1], &parameters);

    [Adjust trackEvent:eventToken withParameters:parameters];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject trackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    double revenue;
    NSString *eventToken;
    NSDictionary *parameters;

    FREGetObjectAsDouble(argv[0], &revenue);
    FREGetObjectAsNativeString(argv[1], &eventToken);
    FREGetObjectAsNativeDictionary(argv[2], &parameters);

    [Adjust trackRevenue:revenue forEvent:eventToken withParameters:parameters];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject setEnable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    BOOL enable;

    FREGetObjectAsNativeBool(argv[0], &enable);

    [Adjust setEnabled:enable];

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject isEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    BOOL isEnabled = [Adjust isEnabled];

    FREObject return_value;
    FRENewObjectFromBool((uint32_t)isEnabled, &return_value);
    return return_value;
}

FREObject setResponseDelegate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    AdjustFREContext = ctx;
    AdjustFunctionInstance = [[AdjustFunction alloc] init];
    [Adjust setDelegate:AdjustFunctionInstance];

    FREObject return_value;
    FRENewObjectFromBool((uint32_t)isEnabled, &return_value);
    return return_value;
}

FREObject onResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)isEnabled, &return_value);
    return return_value;
}

FREObject onPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject return_value;
    FRENewObjectFromBool((uint32_t)isEnabled, &return_value);
    return return_value;
}
