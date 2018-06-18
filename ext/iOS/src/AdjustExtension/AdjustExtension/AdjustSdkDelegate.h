//
//  AdjustSdkDelegate.h
//  Adjust
//
//  Created by Abdullah on 2016-12-15
//  Copyright (c) 2012-2016 adjust GmbH. All rights reserved.
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
