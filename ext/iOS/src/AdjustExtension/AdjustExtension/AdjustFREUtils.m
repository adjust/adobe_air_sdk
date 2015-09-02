//
//  AdjustFREUtils.m
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustFREUtils.h"


FREResult FREGetObjectAsNativeString(FREObject obj, NSString** nativeString)
{
    FREResult result;
    uint32_t length;
    const uint8_t *value;

    result = FREGetObjectAsUTF8(obj, &length, &value);
    ASSERT_FRE_OK(result);

    *nativeString = [NSString stringWithUTF8String: (const char*)value];
    return result;
}

FREResult FREGetObjectAsNativeBool(FREObject obj, BOOL* nativeBool)
{
    FREResult result;
    uint32_t value;

    result = FREGetObjectAsBool(obj, &value);
    ASSERT_FRE_OK(result);

    *nativeBool = (BOOL) value;
    return result;
}

FREResult FREGetObjectAsNativeArray(FREObject obj, NSArray** nativeArray)
{
    FREResult result;
    FREObject array = obj;
    uint32_t arrayLength;
    NSMutableArray *mutableArray;

    result = FREGetArrayLength(array, &arrayLength);
    ASSERT_FRE_OK(result);

    mutableArray = [[NSMutableArray alloc] initWithCapacity:arrayLength];

    for (uint32_t i = 0; i < arrayLength; i++) {
        FREObject element;

        result = FREGetArrayElementAt(array, i, &element);
        ASSERT_FRE_OK(result);

        NSString *nativeElement;

        result = FREGetObjectAsNativeString(element, &nativeElement);
        ASSERT_FRE_OK(result);

        [mutableArray addObject:nativeElement];
    }

    *nativeArray = (NSArray *)mutableArray;

    return result;
}

FREResult FREGetObjectAsNativeDictionary(FREObject obj, NSDictionary** nativeDictionary)
{
    FREResult result;
    FREObject arrayKeys;
    FREObject exception;
    const uint8_t *propertyName = (const uint8_t*)"adjust keys";
    uint32_t arrayLength;
    NSMutableDictionary *mutableDictionary;

    // get adjust keys array
    result = FREGetObjectProperty(obj, propertyName, &arrayKeys, &exception);
    ASSERT_FRE_OK(result);

    // iterate array keys to extract properties
    result = FREGetArrayLength(arrayKeys, &arrayLength);
    ASSERT_FRE_OK(result);

    mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:arrayLength];

    for (uint32_t i = 0; i < arrayLength; i++) {
        FREObject key;
        const uint8_t *keyAS3String;
        uint32_t keyLength;
        FREObject value;

        // get key
        result = FREGetArrayElementAt(arrayKeys, i, &key);
        ASSERT_FRE_OK(result);

        result = FREGetObjectAsUTF8(key, &keyLength, &keyAS3String);
        ASSERT_FRE_OK(result);

        // get value
        FREGetObjectProperty(obj, keyAS3String, &value, &exception);
        ASSERT_FRE_OK(result);

        NSString *nativeKey;
        NSString *nativeValue;

        result = FREGetObjectAsNativeString(key, &nativeKey);
        ASSERT_FRE_OK(result);

        result = FREGetObjectAsNativeString(value, &nativeValue);
        ASSERT_FRE_OK(result);

        // add to dictionary
        [mutableDictionary setObject:nativeValue forKey:nativeKey];
    }

    *nativeDictionary = (NSDictionary*) mutableDictionary;

    return result;
}

