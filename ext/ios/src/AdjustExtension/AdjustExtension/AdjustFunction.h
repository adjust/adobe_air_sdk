//
//  AdjustFunction.h
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "Adjust.h"

@interface AdjustFunction: NSObject<AdjustDelegate>

- (void)adjustFinishedTrackingWithResponse:(AIResponseData *)responseData;

@end

FREObject appDidLaunch(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject trackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject trackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject setEnable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject isEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject onResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject onPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject setResponseDelegate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
