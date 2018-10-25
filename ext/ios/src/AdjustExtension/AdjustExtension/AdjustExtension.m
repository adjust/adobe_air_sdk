//
//  AdjustExtension.m
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

#import "AdjustFunction.h"

void setNamedFunction(FRENamedFunction* namedFunction, const uint8_t* name, FREFunction function) {
    namedFunction->name = name;
    namedFunction->functionData = NULL;
    namedFunction->function = function;
}

void AdjustFREContextInitializer(void* extData,
    const uint8_t* ctxType,
    FREContext ctx,
    uint32_t* numFunctionsToSet,
    const FRENamedFunction** functionsToSet) {
    uint32_t numberOfFunctions = 24;

    *numFunctionsToSet = numberOfFunctions;

    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * numberOfFunctions);
    setNamedFunction(&func[0], (const uint8_t*)"onCreate", &ADJonCreate);
    setNamedFunction(&func[1], (const uint8_t*)"trackEvent", &ADJtrackEvent);
    setNamedFunction(&func[2], (const uint8_t*)"setEnabled", &ADJsetEnabled);
    setNamedFunction(&func[3], (const uint8_t*)"isEnabled", &ADJisEnabled);
    setNamedFunction(&func[4], (const uint8_t*)"onResume", &ADJonResume);
    setNamedFunction(&func[5], (const uint8_t*)"onPause", &ADJonPause);
    setNamedFunction(&func[6], (const uint8_t*)"appWillOpenUrl", &ADJappWillOpenUrl);
    setNamedFunction(&func[7], (const uint8_t*)"setOfflineMode", &ADJsetOfflineMode);
    setNamedFunction(&func[8], (const uint8_t*)"setDeviceToken", &ADJsetDeviceToken);
    setNamedFunction(&func[9], (const uint8_t*)"getIdfa", &ADJgetIdfa);
    setNamedFunction(&func[10], (const uint8_t*)"setReferrer", &ADJsetReferrer);
    setNamedFunction(&func[11], (const uint8_t*)"getGoogleAdId", &ADJgetGoogleAdId);
    setNamedFunction(&func[11], (const uint8_t*)"getAmazonAdId", &ADJgetAmazonAdId);
    setNamedFunction(&func[12], (const uint8_t*)"addSessionCallbackParameter", &ADJaddSessionCallbackParameter);
    setNamedFunction(&func[13], (const uint8_t*)"removeSessionCallbackParameter", &ADJremoveSessionCallbackParameter);
    setNamedFunction(&func[14], (const uint8_t*)"resetSessionCallbackParameters", &ADJresetSessionCallbackParameters);
    setNamedFunction(&func[15], (const uint8_t*)"addSessionPartnerParameter", &ADJaddSessionPartnerParameter);
    setNamedFunction(&func[16], (const uint8_t*)"removeSessionPartnerParameter", &ADJremoveSessionPartnerParameter);
    setNamedFunction(&func[17], (const uint8_t*)"resetSessionPartnerParameters", &ADJresetSessionPartnerParameters);
    setNamedFunction(&func[18], (const uint8_t*)"sendFirstPackages", &ADJsendFirstPackages);
    setNamedFunction(&func[19], (const uint8_t*)"getAdid", &ADJgetAdid);
    setNamedFunction(&func[20], (const uint8_t*)"getAttribution", &ADJgetAttribution);
    setNamedFunction(&func[21], (const uint8_t*)"gdprForgetMe", &ADJgdprForgetMe);
    setNamedFunction(&func[22], (const uint8_t*)"setTestOptions", &ADJsetTestOptions);
    setNamedFunction(&func[23], (const uint8_t*)"teardown", &ADJteardown);

    *functionsToSet = func;
}

void AdjustFREContextFinalizer(FREContext ctx) {
    return;
}

void AdjustFREInitializer(void** extDataToSet,
    FREContextInitializer* ctxInitializerToSet,
    FREContextFinalizer* ctxFinalizerToSet) {
    extDataToSet = NULL;
    *ctxInitializerToSet = &AdjustFREContextInitializer;
    *ctxFinalizerToSet = &AdjustFREContextFinalizer;
}

void AdjustFREFinalizer(void* extData) {
    return;
}

