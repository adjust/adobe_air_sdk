//
//  AdjustSdkDelegate.m
//  Adjust SDK
//
//  Created by Abdullah Obaied on 15th December 2016.
//  Copyright (c) 2016-Present Adjust GmbH. All rights reserved.
//

#import <objc/runtime.h>

#import "AdjustSdkDelegate.h"
#import "AdjustFREUtils.h"

static dispatch_once_t onceToken;
static AdjustSdkDelegate *defaultInstance = nil;

@implementation AdjustSdkDelegate

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
                             eventSuccessCallback:(BOOL)swizzleEventSuccessCallback
                             eventFailureCallback:(BOOL)swizzleEventFailureCallback
                           sessionSuccessCallback:(BOOL)swizzleSessionSuccessCallback
                           sessionFailureCallback:(BOOL)swizzleSessionFailureCallback
                         deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                              skanUpdatedCallback:(BOOL)swizzleSkanUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                    withFREContext:(FREContext *)freContext {
    dispatch_once(&onceToken, ^{
        defaultInstance = [[AdjustSdkDelegate alloc] init];
        
        // Do the swizzling where and if needed.
        if (swizzleAttributionCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustAttributionChanged:)
                                  swizzledSelector:@selector(adjustAttributionChangedWannabe:)];
        }
        if (swizzleEventSuccessCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustEventTrackingSucceededWannabe:)];
        }
        if (swizzleEventFailureCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingFailed:)
                                  swizzledSelector:@selector(adjustEventTrackingFailedWannabe:)];
        }
        if (swizzleSessionSuccessCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustSessionTrackingSucceededWannabe:)];
        }
        if (swizzleSessionFailureCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingFailed:)
                                  swizzledSelector:@selector(adjustSessionTrackingFailedWananbe:)];
        }
        if (swizzleDeferredDeeplinkCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustDeferredDeeplinkReceived:)
                                  swizzledSelector:@selector(adjustDeferredDeeplinkReceivedWannabe:)];
        }
        if (swizzleSkanUpdatedCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSkanUpdatedWithConversionData:)
                                  swizzledSelector:@selector(adjustSkanUpdatedWithConversionDataWannabe:)];
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

    NSString *attributionString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
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
    const char* cResponseData = [attributionString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_attributionCallback",
            (const uint8_t *)cResponseData);
}

- (void)adjustEventTrackingSucceededWannabe:(ADJEventSuccess *)eventSuccess {
    if (nil == eventSuccess) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (eventSuccess.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:eventSuccess.jsonResponse
                                                                   options:0
                                                                     error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }
    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", eventSuccess.message,
                                 @"timestamp", eventSuccess.timestamp,
                                 @"adid", eventSuccess.adid,
                                 @"eventToken", eventSuccess.eventToken,
                                 @"callbackId", eventSuccess.callbackId,
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_eventSuccessCallback",
            (const uint8_t *)cResponseData);
}

- (void)adjustEventTrackingFailedWannabe:(ADJEventFailure *)eventFailed {
    if (nil == eventFailed) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (eventFailed.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:eventFailed.jsonResponse
                                                                   options:0
                                                                     error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }
    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", eventFailed.message,
                                 @"timestamp", eventFailed.timestamp,
                                 @"adid", eventFailed.adid,
                                 @"eventToken", eventFailed.eventToken,
                                 @"callbackId", eventFailed.callbackId,
                                 @"willRetry", eventFailed.willRetry ? @"true" : @"false",
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_eventFailureCallback",
            (const uint8_t *)cResponseData);
}


- (void)adjustSessionTrackingSucceededWannabe:(ADJSessionSuccess *)sessionSuccess {
    if (nil == sessionSuccess) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (sessionSuccess.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:sessionSuccess.jsonResponse
                                                                   options:0
                                                                     error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }
    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", sessionSuccess.message,
                                 @"timestamp", sessionSuccess.timestamp,
                                 @"adid", sessionSuccess.adid,
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_sessionSuccessCallback",
            (const uint8_t *)cResponseData);
}

- (void)adjustSessionTrackingFailedWananbe:(ADJSessionFailure *)sessionFailed {
    if (nil == sessionFailed) {
        return;
    }

    NSString *stringJsonResponse = nil;
    if (sessionFailed.jsonResponse != nil) {
        NSData *dataJsonResponse = [NSJSONSerialization dataWithJSONObject:sessionFailed.jsonResponse
                                                                   options:0
                                                                     error:nil];
        stringJsonResponse = [[NSString alloc] initWithBytes:[dataJsonResponse bytes]
                                                      length:[dataJsonResponse length]
                                                    encoding:NSUTF8StringEncoding];
    }
    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"message", sessionFailed.message,
                                 @"timestamp", sessionFailed.timestamp,
                                 @"adid", sessionFailed.adid,
                                 @"willRetry", sessionFailed.willRetry ? @"true" : @"false",
                                 @"jsonResponse", stringJsonResponse];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_sessionFailureCallback",
            (const uint8_t *)cResponseData);
}

- (BOOL)adjustDeferredDeeplinkReceivedWannabe:(NSURL *)deeplink {
    NSString *formattedString = [NSString stringWithFormat:@"%@", deeplink.absoluteString];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_deferredDeeplinkCallback",
            (const uint8_t *)cResponseData);
    return _shouldLaunchDeferredDeeplink;
}

- (void)adjustSkanUpdatedWithConversionDataWannabe:(nonnull NSDictionary<NSString *, NSString *> *)data {
    NSString *formattedString = [NSString stringWithFormat:@"%@==%@__%@==%@__%@==%@__%@==%@",
                                 @"conversionValue", data[@"conversion_value"],
                                 @"coarseValue", data[@"coarse_value"],
                                 @"lockWindow", data[@"lock_window"],
                                 @"error", data[@"error"]];
    const char* cResponseData = [formattedString UTF8String];
    FREDispatchStatusEventAsync(*_adjustFREContext,
            (const uint8_t *)"adjust_skanUpdatedCallback",
            (const uint8_t *)cResponseData);
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
