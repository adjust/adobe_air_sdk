//
//  AdjustTestExtension.m
//  AdjustTestExtension
//
//  Created by Abdullah Obaied (@obaied) on 20th February 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
//

#import "AdjustTestFunction.h"

void setNamedFunction(FRENamedFunction* namedFunction, const uint8_t* name, FREFunction function) {
    namedFunction->name = name;
    namedFunction->functionData = NULL;
    namedFunction->function = function;
}

void AdjustTestFREContextInitializer(void* extData,
                                     const uint8_t* ctxType,
                                     FREContext ctx,
                                     uint32_t* numFunctionsToSet,
                                     const FRENamedFunction** functionsToSet) {
    uint32_t numberOfFunctions = 5;
    *numFunctionsToSet = numberOfFunctions;

    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * numberOfFunctions);
    setNamedFunction(&func[0], (const uint8_t*)"startTestSession", &ADJstartTestSession);
    setNamedFunction(&func[1], (const uint8_t*)"addInfoToSend", &ADJaddInfoToSend);
    setNamedFunction(&func[2], (const uint8_t*)"sendInfoToServer", &ADJsendInfoToServer);
    setNamedFunction(&func[3], (const uint8_t*)"addTest", &ADJaddTest);
    setNamedFunction(&func[4], (const uint8_t*)"addTestDirectory", &ADJaddTestDirectory);

    *functionsToSet = func;
}

void AdjustTestFREContextFinalizer(FREContext ctx) {
    return;
}

void AdjustTestFREInitializer(void** extDataToSet,
                              FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet) {
    extDataToSet = NULL;
    *ctxInitializerToSet = &AdjustTestFREContextInitializer;
    *ctxFinalizerToSet = &AdjustTestFREContextFinalizer;
}

void AdjustTestFREFinalizer(void* extData) {
    return;
}

