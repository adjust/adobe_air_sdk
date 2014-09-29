//
//  AdjustExtension.m
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustFunction.h"

void setNamedFunction(FRENamedFunction* namedFunction, const uint8_t* name, FREFunction function)
{
    namedFunction->name = name;
    namedFunction->functionData = NULL;
    namedFunction->function = function;
}

void AdjustFREContextInitializer(void* extData,
                                 const uint8_t* ctxType,
                                 FREContext ctx,
                                 uint32_t* numFunctionsToSet,
                                 const FRENamedFunction** functionsToSet)
{
    *numFunctionsToSet = 8;

    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*8);
    setNamedFunction(&func[0], (const uint8_t*)"appDidLaunch", &appDidLaunch);
    setNamedFunction(&func[1], (const uint8_t*)"trackEvent", &trackEvent);
    setNamedFunction(&func[2], (const uint8_t*)"trackRevenue", &trackRevenue);
    setNamedFunction(&func[3], (const uint8_t*)"setEnable", &setEnable);
    setNamedFunction(&func[4], (const uint8_t*)"isEnabled", &isEnabled);
    setNamedFunction(&func[5], (const uint8_t*)"onResume", &onResume);
    setNamedFunction(&func[6], (const uint8_t*)"onPause", &onPause);
    setNamedFunction(&func[7], (const uint8_t*)"setResponseDelegate", &setResponseDelegate);

    *functionsToSet = func;
}

void AdjustFREContextFinalizer(FREContext ctx)
{
    return;
}
void AdjustFREInitializer(void** extDataToSet,
                          FREContextInitializer* ctxInitializerToSet,
                          FREContextFinalizer* ctxFinalizerToSet)
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &AdjustFREContextInitializer;
    *ctxFinalizerToSet = &AdjustFREContextFinalizer;
}

void AdjustFREFinalizer(void* extData)
{
    return;
}

