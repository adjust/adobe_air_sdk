//
//  AdjustExtension.m
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-Present Adjust GmbH. All rights reserved.
//

#import "AdjustFunction.h"

void setNamedFunction(FRENamedFunction* namedFunction, const uint8_t* name, FREFunction function) {
    namedFunction->name = name;
    namedFunction->functionData = NULL;
    namedFunction->function = function;
}

void AdjustFREContextInitializer(
    void* extData,
    const uint8_t* ctxType,
    FREContext ctx,
    uint32_t* numFunctionsToSet,
    const FRENamedFunction** functionsToSet) {
    uint32_t numberOfFunctions = 41;

    *numFunctionsToSet = numberOfFunctions;

    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * numberOfFunctions);
    // common
    setNamedFunction(&func[0], (const uint8_t*)"initSdk", &ADJinitSdk);
    setNamedFunction(&func[1], (const uint8_t*)"enable", &ADJenable);
    setNamedFunction(&func[2], (const uint8_t*)"disable", &ADJdisable);
    setNamedFunction(&func[3], (const uint8_t*)"switchToOfflineMode", &ADJswitchToOfflineMode);
    setNamedFunction(&func[4], (const uint8_t*)"switchBackToOnlineMode", &ADJswitchBackToOnlineMode);
    setNamedFunction(&func[5], (const uint8_t*)"trackEvent", &ADJtrackEvent);
    setNamedFunction(&func[6], (const uint8_t*)"trackAdRevenue", &ADJtrackAdRevenue);
    setNamedFunction(&func[7], (const uint8_t*)"trackThirdPartySharing", &ADJtrackThirdPartySharing);
    setNamedFunction(&func[8], (const uint8_t*)"trackMeasurementConsent", &ADJtrackMeasurementConsent);
    setNamedFunction(&func[9], (const uint8_t*)"processDeeplink", &ADJprocessDeeplink);
    setNamedFunction(&func[10], (const uint8_t*)"processAndResolveDeeplink", &ADJprocessAndResolveDeeplink);
    setNamedFunction(&func[11], (const uint8_t*)"setPushToken", &ADJsetPushToken);
    setNamedFunction(&func[12], (const uint8_t*)"gdprForgetMe", &ADJgdprForgetMe);
    setNamedFunction(&func[13], (const uint8_t*)"addGlobalCallbackParameter", &ADJaddGlobalCallbackParameter);
    setNamedFunction(&func[14], (const uint8_t*)"removeGlobalCallbackParameter", &ADJremoveGlobalCallbackParameter);
    setNamedFunction(&func[15], (const uint8_t*)"removeGlobalCallbackParameters", &ADJremoveGlobalCallbackParameters);
    setNamedFunction(&func[16], (const uint8_t*)"addGlobalPartnerParameter", &ADJaddGlobalPartnerParameter);
    setNamedFunction(&func[17], (const uint8_t*)"removeGlobalPartnerParameter", &ADJremoveGlobalPartnerParameter);
    setNamedFunction(&func[18], (const uint8_t*)"removeGlobalPartnerParameters", &ADJremoveGlobalPartnerParameters);
    setNamedFunction(&func[19], (const uint8_t*)"isEnabled", &ADJisEnabled);
    setNamedFunction(&func[20], (const uint8_t*)"getAdid", &ADJgetAdid);
    setNamedFunction(&func[21], (const uint8_t*)"getAttribution", &ADJgetAttribution);
    setNamedFunction(&func[22], (const uint8_t*)"getSdkVersion", &ADJgetSdkVersion);
    setNamedFunction(&func[23], (const uint8_t*)"getLastDeeplink", &ADJgetLastDeeplink);
    // ios only
    setNamedFunction(&func[24], (const uint8_t*)"trackAppStoreSubscription", &ADJtrackAppStoreSubscription);
    setNamedFunction(&func[25], (const uint8_t*)"verifyAppStorePurchase", &ADJverifyAppStorePurchase);
    setNamedFunction(&func[26], (const uint8_t*)"verifyAndTrackAppStorePurchase", &ADJverifyAndTrackAppStorePurchase);
    setNamedFunction(&func[27], (const uint8_t*)"getIdfa", &ADJgetIdfa);
    setNamedFunction(&func[28], (const uint8_t*)"getIdfv", &ADJgetIdfv);
    setNamedFunction(&func[29], (const uint8_t*)"getAppTrackingStatus", &ADJgetAppTrackingStatus);
    setNamedFunction(&func[30], (const uint8_t*)"requestAppTrackingAuthorization", &ADJrequestAppTrackingAuthorization);
    setNamedFunction(&func[31], (const uint8_t*)"updateSkanConversionValue", &ADJupdateSkanConversionValue);
    // android only
    setNamedFunction(&func[32], (const uint8_t*)"trackPlayStoreSubscription", &ADJtrackPlayStoreSubscription);
    setNamedFunction(&func[33], (const uint8_t*)"verifyPlayStorePurchase", &ADJverifyPlayStorePurchase);
    setNamedFunction(&func[34], (const uint8_t*)"verifyAndTrackPlayStorePurchase", &ADJverifyAndTrackPlayStorePurchase);
    setNamedFunction(&func[35], (const uint8_t*)"getGoogleAdId", &ADJgetGoogleAdId);
    setNamedFunction(&func[36], (const uint8_t*)"getAmazonAdId", &ADJgetAmazonAdId);
    // testing only
    setNamedFunction(&func[37], (const uint8_t*)"onResume", &ADJonResume);
    setNamedFunction(&func[38], (const uint8_t*)"onPause", &ADJonPause);
    setNamedFunction(&func[39], (const uint8_t*)"setTestOptions", &ADJsetTestOptions);
    setNamedFunction(&func[40], (const uint8_t*)"teardown", &ADJteardown);

    *functionsToSet = func;
}

void AdjustFREContextFinalizer(FREContext ctx) {
    return;
}

void AdjustFREInitializer(
    void** extDataToSet,
    FREContextInitializer* ctxInitializerToSet,
    FREContextFinalizer* ctxFinalizerToSet) {
    extDataToSet = NULL;
    *ctxInitializerToSet = &AdjustFREContextInitializer;
    *ctxFinalizerToSet = &AdjustFREContextFinalizer;
}

void AdjustFREFinalizer(void* extData) {
    return;
}
