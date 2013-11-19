//
//  FREUtils.h
//  AdjustIoExtension
//
//  Created by Andrew Slotin on 18.11.13.
//  Copyright (c) 2013 adeven. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#define ASSERT_FRE_OK(x) if (x != FRE_OK) { return x; }
#define FRE_TRUE [AdjustFREUtils FRETrue]
#define FRE_FALSE [AdjustFREUtils FREFalse]

@interface AdjustFREUtils : NSObject

+(FREObject)FRETrue;
+(FREObject)FREFalse;

@end

FREResult FREGetObjectAsNSString(FREObject obj, NSString** str);
FREResult FREGetObjectAsNSMutableDictionary(FREObject obj, NSMutableDictionary** dict);