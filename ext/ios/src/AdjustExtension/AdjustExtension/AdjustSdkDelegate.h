//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Abdullah Obaied (@obaied) on 15th December 2016.
//  Copyright (c) 2016-2018 Adjust GmbH. All rights reserved.
//

#import "AdjustFREUtils.h"
#import <AdjustSdk/Adjust.h>

@interface AdjustSdkDelegate : NSObject<AdjustDelegate>

@property (nonatomic) BOOL shouldLaunchDeferredDeeplink;
@property (nonatomic) FREContext *adjustFREContext;

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
						   eventSucceededCallback:(BOOL)swizzleEventSucceededCallback
							  eventFailedCallback:(BOOL)swizzleEventFailedCallback
						 sessionSucceededCallback:(BOOL)swizzleSessionSucceededCallback
						    sessionFailedCallback:(BOOL)swizzleSessionFailedCallback
					     deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                         		   withFREContext:(FREContext *)freContext;

+ (void)teardown;

@end
