//
//  AdjustSdkDelegate.m
//  Adjust SDK
//
//  Created by Abdullah Obaied (@obaied) on 15th December 2016.
//  Copyright (c) 2016-2018 Adjust GmbH. All rights reserved.
//

#import <objc/runtime.h>

#import "AdjustSdkDelegate.h"
#import "AdjustFREUtils.h"

static dispatch_once_t onceToken;
static AdjustSdkDelegate *defaultInstance = nil;

@implementation AdjustSdkDelegate

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
                           eventSucceededCallback:(BOOL)swizzleEventSucceededCallback
                              eventFailedCallback:(BOOL)swizzleEventFailedCallback
                         sessionSucceededCallback:(BOOL)swizzleSessionSucceededCallback
                            sessionFailedCallback:(BOOL)swizzleSessionFailedCallback
                         deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                   withFREContext:(FREContext *)freContext {
    dispatch_once(&onceToken, ^{
        defaultInstance = [[AdjustSdkDelegate alloc] init];
        
        // Do the swizzling where and if needed.
        if (swizzleAttributionCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustAttributionChanged:)
                                  swizzledSelector:@selector(adjustAttributionChangedWannabe:)];
        }
        if (swizzleEventSucceededCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustEventTrackingSucceededWannabe:)];
        }
        if (swizzleEventFailedCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingFailed:)
                                  swizzledSelector:@selector(adjustEventTrackingFailedWannabe:)];
        }
        if (swizzleSessionSucceededCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustSessionTrackingSucceededWannabe:)];
        }
        if (swizzleSessionFailedCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingFailed:)
                                  swizzledSelector:@selector(adjustSessionTrackingFailedWananbe:)];
        }
        if (swizzleDeferredDeeplinkCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustDeeplinkResponse:)
                                  swizzledSelector:@selector(adjustDeeplinkResponseWannabe:)];
        }

        [defaultInstance setShouldLaunchDeferredDeeplink:shouldLaunchDeferredDeeplink];
        [defaultInstance setAdjustFREContext:freContext];
    });
    
    return defaultInstance;
}

+ (void)teardown {
    onceToken = 0;
    defaultInstance = nil;
}

- (id)init {
    self = [super init];
    if (nil == self) {
        return nil;
    }
    return self;
}

- (void)adjustAttributionChangedWannabe:(ADJAttribution *)attribution {
    if (attribution == nil) {
        return;
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
    const char* cResponseData = [attributionString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_attributionData",
            (const uint8_t *)cResponseData);
}

- (void)adjustEventTrackingSucceededWannabe:(ADJEventSuccess *)eventSuccess {
    if (nil == eventSuccess) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (eventSuccess.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:eventSuccess.jsonResponse options:0 error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }

    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", eventSuccess.message,
                                 @"timeStamp", eventSuccess.timeStamp,
                                 @"adid", eventSuccess.adid,
                                 @"eventToken", eventSuccess.eventToken,
                                 @"callbackId", eventSuccess.callbackId,
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_eventTrackingSucceeded",
            (const uint8_t *)cResponseData);
}

- (void)adjustEventTrackingFailedWannabe:(ADJEventFailure *)eventFailed {
    if (nil == eventFailed) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (eventFailed.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:eventFailed.jsonResponse options:0 error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }

    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", eventFailed.message,
                                 @"timeStamp", eventFailed.timeStamp,
                                 @"adid", eventFailed.adid,
                                 @"eventToken", eventFailed.eventToken,
                                 @"callbackId", eventFailed.callbackId,
                                 @"willRetry", eventFailed.willRetry ? @"true" : @"false",
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_eventTrackingFailed",
            (const uint8_t *)cResponseData);
}


- (void)adjustSessionTrackingSucceededWannabe:(ADJSessionSuccess *)sessionSuccess {
    if (nil == sessionSuccess) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (sessionSuccess.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:sessionSuccess.jsonResponse options:0 error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }

    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", sessionSuccess.message,
                                 @"timeStamp", sessionSuccess.timeStamp,
                                 @"adid", sessionSuccess.adid,
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_sessionTrackingSucceeded",
            (const uint8_t *)cResponseData);
}

- (void)adjustSessionTrackingFailedWananbe:(ADJSessionFailure *)sessionFailed {
    if (nil == sessionFailed) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (sessionFailed.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:sessionFailed.jsonResponse options:0 error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }

    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", sessionFailed.message,
                                 @"timeStamp", sessionFailed.timeStamp,
                                 @"adid", sessionFailed.adid,
                                 @"willRetry", sessionFailed.willRetry ? @"true" : @"false",
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_sessionTrackingFailed",
            (const uint8_t *)cResponseData);
}

- (BOOL)adjustDeeplinkResponseWannabe:(NSURL *)deeplink {
    NSString *formattedString = [NSString stringWithFormat:@"%@", deeplink.absoluteString];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_deferredDeeplink",
            (const uint8_t *)cResponseData);
    return _shouldLaunchDeferredDeeplink;
}

- (void)swizzleCallbackMethod:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)addValueOrEmpty:(NSMutableDictionary *)dictionary
                    key:(NSString *)key
                  value:(NSObject *)value {
    if (nil != value) {
        [dictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
    } else {
        [dictionary setObject:@"" forKey:key];
    }
}

@end
