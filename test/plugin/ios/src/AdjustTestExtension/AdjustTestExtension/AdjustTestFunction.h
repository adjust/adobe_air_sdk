//
//  AdjustTestFunction.h
//  AdjustTestExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import <AdjustTestLibrary/ATLTestLibrary.h>

@interface AdjustTestFunction: NSObject

@end

FREObject ADJstartTestSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJaddInfoToSend(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJsendInfoToServer(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJaddTest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJaddTestDirectory(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
