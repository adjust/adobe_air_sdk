//
//  AdjustFunction.h
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 7th August 2014.
//  Copyright (c) 2014-Present Adjust GmbH. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import <AdjustSdk/Adjust.h>

@interface AdjustFunction: NSObject

@end

// common
FREObject ADJinitSdk(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJenable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJdisable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJswitchToOfflineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJswitchBackToOnlineMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJtrackEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJtrackAdRevenue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJtrackThirdPartySharing(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJtrackMeasurementConsent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJprocessDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJprocessAndResolveDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJsetPushToken(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgdprForgetMe(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJaddGlobalCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJremoveGlobalCallbackParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJremoveGlobalCallbackParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJaddGlobalPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJremoveGlobalPartnerParameter(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJremoveGlobalPartnerParameters(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJisEnabled(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetAdid(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetAttribution(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetSdkVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetLastDeeplink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
// ios only
FREObject ADJtrackAppStoreSubscription(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJverifyAppStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJverifyAndTrackAppStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetIdfa(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetIdfv(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetAppTrackingStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJrequestAppTrackingAuthorization(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJupdateSkanConversionValue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
// android only
FREObject ADJtrackPlayStoreSubscription(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJverifyPlayStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJverifyAndTrackPlayStorePurchase(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetGoogleAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJgetAmazonAdId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
// testing only
FREObject ADJonResume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJonPause(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJsetTestOptions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADJteardown(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
// utility
NSNumber *convertMilliStringToNumber(NSString *milliS);
