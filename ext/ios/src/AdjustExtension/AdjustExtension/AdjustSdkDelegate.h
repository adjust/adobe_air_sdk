//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Abdullah Obaied on 15th December 2016.
//  Copyright (c) 2016-Present Adjust GmbH. All rights reserved.
//

#import "AdjustFREUtils.h"
#import <AdjustSdk/AdjustSdk.h>

@interface AdjustSdkDelegate : NSObject<AdjustDelegate>

@property (nonatomic) BOOL shouldLaunchDeferredDeeplink;
@property (nonatomic) FREContext *adjustFREContext;

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
                             eventSuccessCallback:(BOOL)swizzleEventSuccessCallback
                             eventFailureCallback:(BOOL)swizzleEventFailureCallback
                           sessionSuccessCallback:(BOOL)swizzleSessionSuccessCallback
                           sessionFailureCallback:(BOOL)swizzleSessionFailureCallback
					     deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                              skanUpdatedCallback:(BOOL)swizzleSkanUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                         		   withFREContext:(FREContext *)freContext;

+ (void)teardown;

@end
