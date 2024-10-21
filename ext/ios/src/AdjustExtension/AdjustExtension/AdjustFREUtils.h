//
//  AdjustFREUtils.h
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-Present Adjust GmbH. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#define ASSERT_FRE_OK(x) if (x != FRE_OK) { return x; }

FREResult FREGetObjectAsNativeString(FREObject obj, NSString** nativeString);
FREResult FREGetObjectAsNativeBool(FREObject obj, BOOL* nativeBool);
FREResult FREGetObjectAsNativeArray(FREObject obj, NSArray** nativeArray);
FREResult FREGetObjectAsNativeDictionary(FREObject obj, NSDictionary** nativeBool);
