//
//  AdjustIoExtensionFunctions.h
//  AdjustIoExtension
//
//  Created by Andrew Slotin on 15.11.13.
//  Copyright (c) 2013 adjust GmbH.  All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AdjustIo.h"
#import "FREUtils.h"

FREObject appDidLaunch(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject onPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject onResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject trackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject trackRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);