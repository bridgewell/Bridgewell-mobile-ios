# Documentation Guide

Bridgewell SDK for iOS.  <br><br>

<b>Version: 1.0</b> 

<br>

# SDK Integration
## Cocoapods
If you are not familiar with using Cocoapods for dependency management, visit their [getting started page](https://guides.cocoapods.org/using/getting-started.html). Once you have your Podfile setup, include the following:

```
target 'MyAmazingApp' do
    pod 'BridgewellSDK'
end
```
Now run `pod install` to add the Bridgewell SDK to project dependencies.

# Config `info.plist` file
Update your app's `Info.plist` file to add this key:
`GADApplicationIdentifier` key with a string value of your AdMob app ID [found in the AdMob UI](https://support.google.com/admob/answer/7356431).

# Add SDK
## Set Bridgewell Server
Once you have a Bridgewell server, you will add them to BW mobile. For example, if you’re using the AppNexus Server.
```
Bridgewell.shared.bridgewellServerAccountId = YOUR_ACCOUNT_ID
Bridgewell.shared.bridgewellServerHost = YOUR_SERVER_HOST
```
If you have opted to host your own BW Server solution, you will need to store the URL to the server in your app. Make sure that your URL points to the /openrtb2/auction endpoint.

```
try? Bridgewell.shared.setCustomBridgewellServer(url: YOUR_CUSTOM_HOST_SERVER)
```
This method throws an exception if the provided URL is invalid.

## Initialize SDK
After you have an account id and host server. You should initialize BW Sdk like this

Once you set the account ID and the Bw Server host, you should initialize the Bw SDK. There are several options for how to do it.

If you integrate Bridgewell with GMA SDK with version equal or higher than 10.7.0, use the following initializer, which checks the compatibility of Bridgewell SDK with GMA SDK used in the app:

```swift
Bridgewell.initializeSDK(gadMobileAdsVersion: GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber) { status, error in
    switch status {
    case .succeeded:
        print("Bw SDK successfully initialized")
    case .failed:
        if let error = error {
            print("An error occurred during Bw SDK initialization: \(error.localizedDescription)")
        }
    case .serverStatusWarning:
        if let error = error {
            print("Bw Server status checking failed: \(error.localizedDescription)")
        }
    default:
        break
    }            
} 
```

If you integrate Bridgewell sdk with GMA SDK with version lower than 10.7.0, use the following initializer:
```swift
Bridgewell.initializeSDK(GADMobileAds.sharedInstance()) { status, error in
    switch status {
    case .succeeded:
        print("Bridgewell SDK successfully initialized")
    case .failed:
        if let error = error {
            print("An error occurred during Bridgewell SDK initialization: \(error.localizedDescription)")
        }
    case .serverStatusWarning:
        if let error = error {
            print("Bridgewell Server status checking failed: \(error.localizedDescription)")
        }
    default:
        break
    }
}
```

Check the log messages of the app. If the provided GMA SDK version is not verified for compatibility, the Bridgewell SDK informs about it.

For the No Ad Server scenario, use the following initialization:
```swift
Bridgewell.initializeSDK { status, error in
    // ....
}
```

During the initialization, SDK creates internal classes and performs the health check request to the /status endpoint. If you use a custom PBS host you should provide a custom status endpoint as well:

```Swift
Bridgewell.shared.customStatusEndpoint = BRIDGEWELL_SERVER_STATUS_ENDPOINT
```

If something goes wrong with the request, the status of the initialization callback will be `.serverStatusWarning`. It doesn’t affect an SDK flow and just informs you about the health check result.

# Setup SDK
The `Bridgewell` class is a singleton that enables the user to apply global settings.

## Properties
`bridgewellServerAccountId`: String containing the Bridgewell Server account ID.

`bridgewellServerHost`: String containing configuration your Bridgewell Server host with which Bridgewell SDK will communicate. Choose from the system-defined Bridgewell Server hosts or define your own custom Bridgewell Server host.

`shareGeocoordinate`: Optional Bool, if this flag is True AND the app collects the user’s geographical location data, Bridgewell Mobile will send the user’s geographical location data to Bridgewell Server. If this flag is False OR the app does not collect the user’s geographical location data, Bridgewell Mobile will not populate any user geographical location information in the call to Bridgewell Server. The default setting is false.

`logLevel`: Optional level of logging to output in the console. Options are one of the following sorted by a verbosity of the log:

```Swift
public static let debug = LogLevel(stringValue: "[💬]", rawValue: 0)
public static let verbose = LogLevel(stringValue: "[🔬]", rawValue: 1)
public static let info = LogLevel(stringValue: "[ℹ️]", rawValue: 2)
public static let warn = LogLevel(stringValue: "[⚠️]", rawValue: 3)
public static let error = LogLevel(stringValue: "[‼️]", rawValue: 4)
public static let severe = LogLevel(stringValue: "[🔥]", rawValue: 5)
```

`timeoutMillis`: The Bridgewell timeout (accessible to Bridgewell SDK 1.2+), set in milliseconds, will return control to the ad server SDK to fetch an ad once the expiration period is achieved. Because Bridgewell SDK solicits bids from Bridgewell Server in one payload, setting Bridgewell timeout too low can stymie all demand resulting in a potential negative revenue impact.

`creativeTimeout`: Controls how long banner creative has to load before it is considered a failure.

`creativeTimeoutPreRenderContent`: Controls how long video and interstitial creatives have to load before it is considered a failure.

`cachedAuctionResponse`: Set as type string, stored auction responses signal Bridgewell Server to respond with a static response matching the storedAuctionResponse found in the Bridgewell Server Database, useful for debugging and integration testing. No bid requests will be sent to any bidders when a matching storedAuctionResponse is found. For more information on how stored auction responses work, refer to the written description on github issue 133.

`bwsDebug`: adds the debug flag (“test”:1) on the outbound http call to Bridgewell Server. The test:1 flag will signal to Bridgewell Server to emit the full resolved request (resolving any Stored Request IDs) as well as the full Bid Request and Bid Response to and from each bidder.

## Methods
### Stored Response

addStoredBidResponse: Function containing two properties:

bidder: Bidder name as defined by Bridgewell Server bid adapter of type string.
responseId: Configuration ID used in the Bridgewell Server Database to store static bid responses.
Stored Bid Responses are similar to Stored Auction Responses in that they signal to Bridgewell Server to respond with a static pre-defined response, except Stored Bid Responses is done at the bidder level, with bid requests sent out for any bidders not specified in the bidder parameter. For more information on how stored auction responses work
```swift
func addStoredBidResponse(bidder: String, responseId: String)
```

clearStoredBidResponses: Clears any stored bid responses.

```swift 
func clearStoredBidResponses()
```

### Custom headers
The following methods enable the customization of the HTTP call to the Bridgewell server:

```swift
func addCustomHeader(name: String, value: String) 
```
```swift
func clearCustomHeaders()
``` 

## Examples
```swift
// Host
Bridgewell.shared.BridgewellServerHost = .Rubicon
// or set a custom host
Bridgewell.shared.BridgewellServerHost = BridgewellHost.Custom
do {
    try Bridgewell.shared.setCustomBridgewellServer(url: "https://Bridgewell-server.customhost.com")
} catch {
    print(error)
}

// Account Id
Bridgewell.shared.BridgewellServerAccountId = "1234"

// Geolocation
Bridgewell.shared.shareGeoLocation = true

// Log level data
Bridgewell.shared.logLevel = .verbose

// Set Bridgewell timeout in milliseconds
Bridgewell.shared.timeoutMillis = 3000

// Enable Bridgewell Server debug respones
Bridgewell.shared.pbsDebug = true

// Stored responses  can be one of storedAuction response or storedBidResponse
Bridgewell.shared.storedAuctionResponse = "111122223333"

//or
Bridgewell.shared.addStoredBidResponse(bidder: "appnexus", responseId: "221144")
Bridgewell.shared.addStoredBidResponse(bidder: "rubicon", responseId: "221155")
```

# Ad setup
## Custom Bidding Integration
You can use Bridgewell SDK to monetize your app with a custom ad server or even without it. Use the Rendering API to display the winning bid without primary ad server and its SDK.
 
### Banner API
 Integration example:
```swift
// 1. Create an Ad View
let banner = BannerView(frame: CGRect(origin: .zero, size: adSize),
                        configID: CONFIG_ID,
                        adSize: adSize)

banner.delegate = self

// 2. Load an Ad
banner.loadAd()
```

**Step 1: Create Ad View**

Initialize the BannerAdView with properties:
- frame - the frame rectangle for the view
- configID - an ID of the Stored Impression on the Bridgewell Server
- size - the size of the ad unit which will be used in the bid request.

<br>

**Step 2: Load the Ad**

Call the method loadAd() which will:
- make a bid request to the Bridgewell Server.
- render the winning bid on display.

**Outstream Video**

For Banner Video you also need to specify the ad format:
```swift
banner.adFormat = .video
```

### Interstitial API
Integration example:
```swift 
// 1. Create an Interstitial Ad Unit
interstitial = InterstitialRenderingAdUnit(configID: CONFIG_ID,
                                  minSizePercentage: CGSize(width: 30, height: 30))

interstitial.delegate = self

// 2. Load an Ad
interstitial.loadAd()

// .....

// 3. Show An Ad
if interstitial.isReady {
    interstitial.show(from: self)
}
```
The default ad format for interstitial is .banner. In order to make a multiformat bid request, set the respective values into the adFormats property.
```swift
// Make bid request for video ad
adUnit?.adFormats = [.video]

// Make bid request for both video and banner ads
adUnit?.adFormats = [.video, .banner]

// Make bid request for banner ad (default behaviour)
adUnit?.adFormats = [.banner]
```

#### Step 1: Create an Ad Unit
Initialize the Interstitial Ad Unit with properties:
- configID - an ID of Stored Impression on the Bridgewell Server
- minSizePercentage - specifies the minimum width and height percent an ad may occupy of a device’s real estate.
  
**NOTE**: minSizePercentage - plays an important role in a bidding process for banner ads. If provided space is not enough demand partners won’t respond with the bids.

#### Step 2: Load the Ad
Call the method **loadAd()** which will make a bid request to Bridgewell server.

#### Step 3: Show the Ad when it is ready
Wait until the ad will be loaded and present it to the user in any suitable time.

```swift
// MARK: InterstitialRenderingAdUnitDelegate

func interstitialDidReceiveAd(_ interstitial: InterstitialRenderingAdUnit) {
    // Now the ad is ready for display
}
```

### Rewarded API
Integration example:
```swift
// 1. Create an Ad Unit
rewardedAd = RewardedAdUnit(configID: CONFIG_ID)
rewardedAd.delegate = self

// 2. Load an Ad
rewardedAd.loadAd()

/// .......

// 3. Display the Ad
if rewardedAd.isReady {
    rewardedAd.show(from: self)
}
```
#### Step 1: Create Rewarded Ad Unit
Create the RewardedAdUnit object with parameter:
- configID - an ID of Stored Impression on the Bridgewell Server
#### Step 2: Load the Ad
Call the `loadAd()` method which will make a bid request to Bridgewell server.
#### Step 3: Show the Ad when it is ready
Wait until the ad will be loaded and present it to the user in any suitable time.

```swift
// MARK: RewardedAdUnitDelegate

func rewardedAdDidReceiveAd(_ rewardedAd: RewardedAdUnit) {
    // Now the ad is ready for display
}
```







# About
Copyright 2024 Bridgewell | All Rights Reserved