//
//  AdjustIoExtensionFunctions.m
//  AdjustIoExtension
//
//  Created by Andrew Slotin on 15.11.13.
//  Copyright (c) 2013 adeven. All rights reserved.
//

#import "AdjustIoExtensionFunctions.h"

FREObject appDidLaunch(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t as3_stringBufferLength;
    const uint8_t *as3_stringBuffer;
    FREResult result;
    NSString *environment = AIEnvironmentProduction;
    AILogLevel logLevel = AILogLevelInfo;
    BOOL eventBufferingEnabled = NO;

    if (argc == 0)
    {
        [AILogger error:@"Please provide the app token before initializing."];
        return FRE_FALSE;
    }

    result = FREGetObjectAsUTF8(argv[0], &as3_stringBufferLength, &as3_stringBuffer);
    if (result != FRE_OK)
    {
        [AILogger error:@"Failed to fetch appToken: %d", result];
        return FRE_FALSE;
    }

    NSString *appToken = [NSString stringWithUTF8String: (char*)as3_stringBuffer];

    if (argc > 1) {
        result = FREGetObjectAsUTF8(argv[1], &as3_stringBufferLength, &as3_stringBuffer);
        if (result != FRE_OK)
        {
            [AILogger error:@"Failed to fetch environment: %d", result];
            return FRE_FALSE;
        }

        environment = [NSString stringWithUTF8String: (char*)as3_stringBuffer];
    }

    if (argc > 2) {
        result = FREGetObjectAsUint32(argv[2], &logLevel);
        if (result != FRE_OK)
        {
            [AILogger warn:@"Failed to fetch log level: %d, falling back to INFO", result];
        } else {
            logLevel += 1; // For conformity with Android part
        }
    }

    if (argc > 3) {
        result = FREGetObjectAsBool(argv[3], &eventBufferingEnabled);
        if (result != FRE_OK)
        {
            [AILogger warn:@"Failed to fetch event buffering enabled: %d, turning it off", result];
        }
    }

    [AdjustIo appDidLaunch: appToken];
    [AdjustIo setEnvironment:environment];
    [AdjustIo setLogLevel:logLevel];
    [AdjustIo setEventBufferingEnabled:eventBufferingEnabled];

    return FRE_TRUE;
}

FREObject onPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return FRE_TRUE;
}

FREObject onResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return FRE_TRUE;
}

FREObject trackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREResult result;
    NSString *eventToken;
    NSMutableDictionary *parameters = nil;

    if (argc == 0)
    {
        [AILogger error:@"Cannot track an event without event token specified"];
        return FRE_FALSE;
    }

    result = FREGetObjectAsNSString(argv[0], &eventToken);
    if (result != FRE_OK)
    {
        [AILogger error:@"Failed to get event token: %d", result];
        return FRE_FALSE;
    }

    if (argc > 1) {
        result = FREGetObjectAsNSMutableDictionary(argv[1], &parameters);

        if (result != FRE_OK)
        {
            [AILogger error:@"Failed to get event parameters: %d", result];
            return FRE_FALSE;
        }
    }

    [AdjustIo trackEvent:eventToken withParameters:parameters];

    return FRE_TRUE;
}

FREObject trackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    double revenue;
    FREResult result;
    NSString *eventToken;
    NSMutableDictionary *parameters = nil;

    if (argc == 0)
    {
        [AILogger error:@"Cannot track revenue without amount."];
        return FRE_FALSE;
    }

    result = FREGetObjectAsDouble(argv[0], &revenue);
    if (result != FRE_OK)
    {
        [AILogger error:@"Failed to get revenue amount"];
        return FRE_FALSE;
    }

    if (argc > 1)
    {
        result = FREGetObjectAsNSString(argv[1], &eventToken);
        if (result != FRE_OK) {
            [AILogger error:@"Failed to get event token: %d", result];
            return FRE_FALSE;
        }
    }

    if (argc > 2)
    {
        result = FREGetObjectAsNSMutableDictionary(argv[2], &parameters);
        if (result != FRE_OK)
        {
            [AILogger error:@"Failed to get event parameters: %d", result];
            return FRE_FALSE;
        }
    }

    [AdjustIo trackRevenue:revenue forEvent:eventToken withParameters:parameters];

    return FRE_TRUE;
}
