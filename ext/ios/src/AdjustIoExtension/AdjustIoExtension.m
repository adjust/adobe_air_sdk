//
//  AdjustIoExtension.m
//  AdjustIoExtension
//
//  Created by Andrew Slotin on 15.11.13.
//  Copyright (c) 2013 adeven. All rights reserved.
//
#include "AdjustIoExtensionFunctions.h"

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 5;
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 5);
    
    func[0].name = (const uint8_t*) "appDidLaunch";
    func[0].functionData = NULL;
    func[0].function = &appDidLaunch;
    
    func[1].name = (const uint8_t*) "onPause";
    func[1].functionData = NULL;
    func[1].function = &onPause;
    
    
    func[2].name = (const uint8_t*) "onResume";
    func[2].functionData = NULL;
    func[2].function = &onResume;
    
    
    func[3].name = (const uint8_t*) "trackEvent";
    func[3].functionData = NULL;
    func[3].function = &trackEvent;
    
    
    func[4].name = (const uint8_t*) "trackeRevenue";
    func[4].functionData = NULL;
    func[4].function = &trackRevenue;
    
    *functionsToSet = func;
}

void ContextFinalizer(FREContext ctx) {
    return;
}

void AdjustIoExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;
}

void AdjustIoExtensionFinalizer(void* extData)
{
    return;
}