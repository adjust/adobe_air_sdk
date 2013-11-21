//
//  FREUtils.m
//  AdjustIoExtension
//
//  Created by Andrew Slotin on 18.11.13.
//  Copyright (c) 2013 adeven. All rights reserved.
//

#import "FREUtils.h"

@implementation AdjustFREUtils

FREObject _FRE_TRUE  = NULL;
FREObject _FRE_FALSE = NULL;

+(FREObject)FRETrue
{
    if (! _FRE_TRUE)
    {
        FRENewObjectFromBool(true, &_FRE_TRUE);
    }
    
    return _FRE_TRUE;
}

+(FREObject)FREFalse
{
    if (! _FRE_FALSE)
    {
        FRENewObjectFromBool(false, &_FRE_FALSE);
    }
    
    return _FRE_FALSE;
}

@end

FREResult FREGetObjectAsNSString(FREObject obj, NSString** str)
{
    FREResult result;
    uint32_t as3_stringLength;
    const uint8_t *as3_string;
    
    result = FREGetObjectAsUTF8(obj, &as3_stringLength, &as3_string);
    ASSERT_FRE_OK(result)
    
    *str = [NSString stringWithUTF8String: (const char*)as3_string];
    
    return result;
}

FREResult FREGetObjectAsNSMutableDictionary(FREObject obj, NSMutableDictionary** dict)
{
    FREResult result;
    FREObject keys;
    uint32_t keysNum;
    
    result = FRECallObjectMethod(obj, (const uint8_t*)"keys", 0, NULL, &keys, NULL);
    ASSERT_FRE_OK(result);
    
    result = FREGetArrayLength(keys, &keysNum);
    ASSERT_FRE_OK(result);
    
    *dict = [NSMutableDictionary dictionaryWithCapacity:keysNum];
    for (uint32_t i = 0; i < keysNum; i++)
    {
        FREObject as3_value;
        FREObject as3_argv[1];
        FREObjectType as3_type;
        
        NSString *key;
        NSString *value;
        
        result = FREGetArrayElementAt(keys, i, &as3_argv[0]);
        ASSERT_FRE_OK(result);
        
        result = FREGetObjectAsNSString(as3_argv[0], &key);
        ASSERT_FRE_OK(result);
        
        result = FRECallObjectMethod(obj, (const uint8_t*)"getValue", 1, as3_argv, &as3_value, NULL);
        ASSERT_FRE_OK(result);
        
        result = FREGetObjectType(as3_value, &as3_type);
        ASSERT_FRE_OK(result);
        
        if (as3_type != FRE_TYPE_STRING)
        {
            return FRE_TYPE_MISMATCH;
        }
        
        result = FREGetObjectAsNSString(as3_value, &value);
        ASSERT_FRE_OK(result);
        
        [*dict setObject:value forKey:key];
    }
    
    return FRE_OK;
}
