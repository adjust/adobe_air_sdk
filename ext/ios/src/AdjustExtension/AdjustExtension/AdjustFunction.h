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

FREObject AIappDidLaunch(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AItrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AItrackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AIsetEnable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AIisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AIonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AIonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AIsetResponseDelegate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
