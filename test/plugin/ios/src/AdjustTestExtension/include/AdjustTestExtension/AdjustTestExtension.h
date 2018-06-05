//
//  AdjustTestExtension.h
//  AdjustTestExtension
//
//  Created by Abdullah Obaied (@obaied) on 20th February 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
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
