#ifndef WrappingObjC_h
#define WrappingObjC_h
#import <Foundation/Foundation.h>
#import <PrebidMobile/PrebidMobile.h>
#import <PrebidMobile/PrebidMobile-Swift.h>

typedef id<InterstitialAdUnitDelegate> BwsInterstitialAdUnitDelegate;
typedef InterstitialRenderingAdUnit* BwsInterstitialRenderingAdUnit;
typedef NativeRequest* BwsNativeRequest;
typedef NativeAd* BwsNativeAd;
typedef NativeAsset* BwsNativeAsset;
typedef NativeAssetImage* BwsNativeAssetImage;
typedef ImageAsset* BwsImageAsset;
typedef NativeAssetTitle* BwsNativeAssetTitle;
typedef NativeAssetData* BwsNativeAssetData;
typedef NativeEventTracker* BwsNativeEventTracker;
typedef ContextType* BwsContextType;
typedef PlacementType* BwsPlacementType;
typedef ContextSubType* BwsContextSubType;
typedef RewardedVideoAdUnit* BwsRewardedVideoAdUnit;
typedef InstreamVideoAdUnit* BwsInstreamVideoAdUnit;
typedef IMAUtils* BwsIMAUtils;
typedef PrebidHost* BwsBridgewellHost;

typedef enum DataAsset BwsDataAsset;
typedef EventType* BwsEventType;
typedef EventTracking* BwsEventTracking;

typedef id<RewardedAdUnitDelegate> BwsRewardedAdUnitDelegate;
typedef RewardedAdUnit* BwsRewardedAdUnit;
typedef MediationBannerAdUnit* BwsMediationBannerAdUnit;
typedef MediationInterstitialAdUnit* BwsMediationInterstitialAdUnit;
typedef MediationNativeAdUnit* BwsMediationNativeAdUnit;
typedef AdViewUtils* BwsAdViewUtils;
typedef BannerAdUnit* BwsBannerAdUnit;
typedef BannerParameters* BwsBannerParameters;
typedef Signals* BwsSignals;
typedef InterstitialAdUnit* BwsInterstitialAdUnit;
typedef VideoParameters* BwsVideoParameters;
typedef id<NativeAdDelegate> BwsNativeAdDelegate;
typedef AdUnit* BwsBridgewellAdUnit;
typedef NativeParameters* BwsNativeParameters;
typedef PrebidRequest* BwsRequest;
typedef Utils* BwsUtils;
typedef MediationRewardedAdUnit* BwsMediationRewardedAdUnit;
typedef PBMLogLevel* BwsLogLevel;
typedef AdFormat* BwsAdFormat;

typedef void (^BwsRegisterWebviewCallback)(NSString * _Nullable, NSError * _Nullable);

#endif /* WrappingObjC_h */





