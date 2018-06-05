//
//  AdjustTestFunction.h
//  AdjustTestExtension
//
//  Created by Abdullah Obaied (@obaied) on 20th February 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
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
