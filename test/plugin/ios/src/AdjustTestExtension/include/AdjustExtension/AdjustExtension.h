//
//  AdjustExtension.h
//  AdjustExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

void AdjustTestFREInitializer(void** extDataToSet,
                          FREContextInitializer* ctxInitializerToSet,
                          FREContextFinalizer* ctxFinalizerToSet);

void AdjustTestFREContextInitializer(void* extData,
                                 const uint8_t* ctxType,
                                 FREContext ctx, uint32_t* numFunctionsToTest,
                                 const FRENamedFunction** functionsToSet);

void setNamedFunction(FRENamedFunction namedFunction, const uint8_t* name, FREFunction function);
