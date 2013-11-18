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
    uint32_t appTokenLength;
    const uint8_t *as3_appToken;
    
    if (argc == 0)
    {
        return NULL;
    }
    
    FREGetObjectAsUTF8(argv[0], &appTokenLength, &as3_appToken);
    NSString *appToken = [NSString stringWithUTF8String: (char*)as3_appToken];
    
    [AdjustIo appDidLaunch: appToken];
    [AdjustIo setEnvironment:AIEnvironmentSandbox];
    [AdjustIo setLogLevel:AILogLevelVerbose];
    
    return NULL;
}

FREObject onPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return NULL;
}

FREObject onResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return NULL;
}

FREObject trackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t eventTokenLength;
    const uint8_t *as3_eventToken;
    NSString *eventToken;
    
    if (argc == 0)
    {
        return NULL;
    }
    
    FREGetObjectAsUTF8(argv[0], &eventTokenLength, &as3_eventToken);
    eventToken = [NSString stringWithUTF8String: (char*)as3_eventToken];
    
    [AdjustIo trackEvent:eventToken];
    
    return NULL;
}

FREObject trackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t eventTokenLength;
    const uint8_t *as3_eventToken;
    double revenue;
    NSString *eventToken = nil;
    NSMutableDictionary *parameters = nil;
    
    if (argc == 0)
    {
        return NULL;
    }
    
    FREGetObjectAsDouble(argv[0], &revenue);
    
    if (argc > 1)
    {
        FREGetObjectAsUTF8(argv[1], &eventTokenLength, &as3_eventToken);
        eventToken = [NSString stringWithUTF8String: (char*)as3_eventToken];
    }
    
    [AdjustIo trackRevenue:revenue forEvent:eventToken withParameters:parameters];
    
    return NULL;
}