//
//  AdjustTestFREUtils.h
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//
#import "FlashRuntimeExtensions.h"

#define ASSERT_FRE_OK(x) if (x != FRE_OK) { return x; }

FREResult FREGetObjectAsNativeString(FREObject obj, NSString** nativeString);
FREResult FREGetObjectAsNativeBool(FREObject obj, BOOL* nativeBool);
FREResult FREGetObjectAsNativeArray(FREObject obj, NSArray** nativeArray);
FREResult FREGetObjectAsNativeDictionary(FREObject obj, NSDictionary** nativeBool);
