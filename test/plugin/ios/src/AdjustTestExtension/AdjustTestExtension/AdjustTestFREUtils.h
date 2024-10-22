//
//  AdjustTestFREUtils.h
//  AdjustTestExtension
//
//  Created by Pedro Silva (@nonelse) on 8th July 2014.
//  Copyright © 2014-Present Adjust GmbH. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#define ASSERT_FRE_OK(x) if (x != FRE_OK) { return x; }

FREResult FREGetObjectAsNativeString(FREObject obj, NSString** nativeString);
FREResult FREGetObjectAsNativeBool(FREObject obj, BOOL* nativeBool);
FREResult FREGetObjectAsNativeArray(FREObject obj, NSArray** nativeArray);
FREResult FREGetObjectAsNativeDictionary(FREObject obj, NSDictionary** nativeBool);
