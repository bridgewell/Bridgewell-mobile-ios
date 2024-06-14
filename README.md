# Documentation Guide

# Bridgewell SDK for iOS.
# Version: 0.0.7

# Requirements

- [Xcode](https://developer.apple.com/xcode/) version 14.0 or later
- An app targeting iOS 12 or later.
- [Cocoapods](https://cocoapods.org/) 1.15.0 or later for integrate with SDK.

# SDK Integration
## Cocoapods
If you are not familiar with using Cocoapods for dependency management, visit their [getting started page](https://guides.cocoapods.org/using/getting-started.html). Once you have your Podfile setup, include the following:

```
target 'MyAmazingApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Test SDK
  pod 'BridgewellSDK'
  
  # Should include this at the end of pod file
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end

```
Now run `pod install` to add the Bridgewell SDK to project dependencies.


# Add SDK
## Set Bridgewell Server

First you have to import SDKs for setting it up, often it is in `AppDelegate`
```
import BridgewellSDK
import PrebidMobile
```

Once you have a Bridgewell server, you will add them to BW mobile. For example, if you’re using the AppNexus Server.
```swift
Bridgewell.shared.bridgewellServerAccountId = YOUR_ACCOUNT_ID
```
If you have opted to host your own BW Server solution, you will need to store the URL to the server in your app. Make sure that your URL points to the /openrtb2/auction endpoint.

```swift
try? Bridgewell.shared.setCustomBridgewellServer(url: YOUR_CUSTOM_HOST_SERVER)
```
This method throws an exception if the provided URL is invalid.

## Initialize SDK
After you have an account id and host server. You should initialize BW Sdk like this

Once you set the account ID and the Bw Server host, you should initialize the Bw SDK, use the following initialization:
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

`shareGeocoordinate`: Optional Bool, if this flag is True AND the app collects the user’s geographical location data, Bridgewell Mobile will send the user’s geographical location data to Bridgewell Server. If this flag is False OR the app does not collect the user’s geographical location data, Bridgewell Mobile will not populate any user geographical location information in the call to Bridgewell Server. The default setting is false.

`isLocationUpdatesEnabled`: Optional Bool.
If true, the SDK will periodically try to listen for location updates in order to request location-based ads.

`logLevel`: Optional level of logging to output in the console. Options are one of the following sorted by a verbosity of the log:
The default value of logLevel `logLevel` is `.debug`, here is the list of all level.

```Swift
public static let debug = LogLevel(stringValue: "[💬]", rawValue: 0) // this is default value
public static let verbose = LogLevel(stringValue: "[🔬]", rawValue: 1)
public static let info = LogLevel(stringValue: "[ℹ️]", rawValue: 2)
public static let warn = LogLevel(stringValue: "[⚠️]", rawValue: 3)
public static let error = LogLevel(stringValue: "[‼️]", rawValue: 4)
public static let severe = LogLevel(stringValue: "[🔥]", rawValue: 5)
```

`timeoutMillis`: The Bridgewell timeout (accessible to Bridgewell SDK 1.2+), set in milliseconds, will return control to the ad server SDK to fetch an ad once the expiration period is achieved. Because Bridgewell SDK solicits bids from Bridgewell Server in one payload, setting Bridgewell timeout too low can stymie all demand resulting in a potential negative revenue impact. default value is 2000ms (2s).

`creativeTimeout`: Controls how long banner creative has to load before it is considered a failure. Default is 6.0 (seconds)

`creativeTimeoutPreRenderContent`: Controls how long video and interstitial creatives have to load before it is considered a failure. Default is 30.0 (seconds)

`cachedAuctionResponse`: Set as type string, stored auction responses signal Bridgewell Server to respond with a static response matching the storedAuctionResponse found in the Bridgewell Server Database, useful for debugging and integration testing. No bid requests will be sent to any bidders when a matching storedAuctionResponse is found. For more information on how stored auction responses work, refer to the written description on github issue 133. This will be `nil` by default.

`bwsDebug`: adds the debug flag (“test”:1) on the outbound http call to Bridgewell Server. The test:1 flag will signal to Bridgewell Server to emit the full resolved request (resolving any Stored Request IDs) as well as the full Bid Request and Bid Response to and from each bidder. Default is `false`


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

### In-App browsers
#### Integrate the WebView API for Ads :
If your iOS app utilizes [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) to display web content, it's recommended to configure it so that content can be optimally monetized with ads.
#### How it work:
The SDK adds some value to javascript `window` object. So they can be access anywhere in javascript code. Then the script can display and optimize the user ads experience.
You have to prepare script to get those value from SDK. 
```
// Property for mobile app device, which include `bundle-id` and `idfa` (optional)
window.bwsMobile
// This is geo location data of the user (optional)
window.bwsGeo
// This is user's device data such as OS version, screen size ... (optional)
window.bwsDevice
```
If setup on iOS correctly, your script can obtain `bwsAccountID` while `bwsIDFA` need your project to be configurated to [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency)
#### Prepare for display media contents and register webview
Default `WKWebView` settings are not optimized for video ads. Use the `WKWebViewConfiguration` APIs to configure your WKWebView for inline playback and automatic video play.
Then we call `registerWebView` function from Bridgewell
Note: Should do all the setup in main thread.
```
class ViewController: UIViewController {

  var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Initialize a WKWebViewConfiguration object.
    let webViewConfiguration = WKWebViewConfiguration()
    // Let HTML videos with a "playsinline" attribute play inline.
    webViewConfiguration.allowsInlineMediaPlayback = true
    // Let HTML videos with an "autoplay" attribute play automatically.
    webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []

    // Initialize the WKWebView with your WKWebViewConfiguration object.
    webView = WKWebView(frame: view.frame, configuration: webViewConfiguration)
    view.addSubview(webView)

    // Register the web view.
    Bridgewell.shared.registerWebView(webView, completion: { // Completion handle   
        // Should load the webview after register it success
        self.loadWebView()
    })

  }

  private func loadWebView() {
    // Load the HTML
    // Load the URL for optimized web view performance.
    guard let url = URL(string: "yourawesomeurl.com") else { return }
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
```
#### Load the webview
1. You can load the HTML content by using URL 
```
// Load the URL for optimized web view performance.
guard let url = URL(string: "yourawesomeurl.com") else { return }
let request = URLRequest(url: url)
webView.load(request)
``` 
2. Or just load HTML string 
```
webView.loadHTMLString("{your_html_string}", baseURL: nil)
```

### SDK will get information from your users to personalized ads. 
All information here are optional, they wont be available without user consent.

__Mobile__
```
// To look up it on HTML, use javascript to retrieve it
window.bwsMobile
```

| Attribute | Type    | Implementation details   |
|-----------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| is_app    | bool    | true                                                                                                                                                                                                                                                                                                           |
| app_id    | string  | The identifier of the mobile app when this ad query comes from a mobile app. <br/>If the app was downloaded from the Apple iTunes app store, then this is the app-store ID; for example, `343200656`. <br/>For Android devices, this is the fully qualified package name; for example, `com.rovio.angrybirds`. |
| idfa/adid | string  | ADID / IDFA fetch from device                                                                                                                                                                                                                                                                                  |

__Geo__
```
// To look up it on HTML, use javascript to retrieve it
window.bwsGeo
```

Geo data will be available if user allow app to access location service. 
Also those two properties `shareGeocoordinate`, `isLocationUpdatesEnabled` should be true 

| Attribute | Type   | Implementation details                                          |
|-----------|--------|-----------------------------------------------------------------|
| lat       | double | Longitude from -180.0 to +180.0, where negative is west.        |
| lon       | double | Longitude from -180.0 to +180.0, where negative is west.        |
| country   | string | Country using ISO-3166-1 Alpha-3.                               |
| ~~region~~    | string | ~~Region code using ISO-3166-2; 2-letter state code if USA.~~       |
| city      | string | City using United Nations Code for Trade & Transport Locations. |
| zip       | string | Zip/postal code.                                                |
| accuracy  | int32  | Estimated location accuracy in meters.                          |
| utcoffset | int32  | Local time as the number +/- of minutes from UTC.               |

__Device__
```
// To look up it on HTML, use javascript to retrieve it
window.bwsDevice
```

| Attribute                         | Type      | imp                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|-----------------------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| platform                          | string    | The platform of the device. Examples: Android, iPhone, Palm.                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| brand                             | string    | The brand of the device (for example, "Apple" or "Samsung").                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| model                             | string    | Device model (for example, "pixel 7 pro"). <br/>For iPhone/iPad, this field contains Apple's model identifier string (such as "iPhone12,1" and "iPad13,8") if available. <br/>Otherwise this field contains the generic model (either "iphone" or "ipad").                                                                                                                                                                                                                                                   |
| os_version                        | OsVersion | The OS version; for example, 2 for Android 2.1, or 3.3 for iOS 3.3.1.                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| carrier_id                        | int64     | Unique identifier for the mobile carrier if the device is connected to the internet through a carrier (as opposed to through WiFi).                                                                                                                                                                                                                                                                                                                                                                          |
| screen_width                      | int32     | The width of the device screen in pixels.                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| screen_height                     | int32     | The height of the device screen in pixels.                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| screen_pixel_ratio_millis         | int32     | Used for high-density devices (for example, iOS retina displays). A non-default value indicates that the nominal screen size (with pixels as the unit) does not describe the actual number of pixels in the screen. For example, nominal width and height may be 320x640 for a screen that actually has 640x1280 pixels, in which case `screen_width=320, screen_height=640`, and `screen_pixel_ratio_millis=2000`, since each axis has twice as many pixels as its dimensions would indicate. Default = `0` |
| screen_orientation                | enum      | The screen orientation of the device when the ad request is sent. Default = **UNKNOWN_ORIENTATION**. <br/>**UNKNOWN_ORIENTATION = 0** <br/>**PORTRAIT = 1** <br/>**LANDSCAPE = 2**                                                                                                                                                                                                                                                                                                                           |
| hardware_version                  | string    | Hardware version of the device. For iPhone/iPad, this field contains Apple's model identifier string (such as "iPhone12,1" and "iPad13,8") if available.                                                                                                                                                                                                                                                                                                                                                     |
| limit_ad_tracking                 | bool      | "Limit Ad Tracking" is a commercially endorsed signal based on the operating system or device settings, where false indicates that tracking is unrestricted and true indicates that tracking must be limited per commercial guidelines. <br/>This signal reflects user decisions on surfaces including iOS App Tracking Transparency. See also lmt and App Tracking Transparency guidance and Android advertising ID.                                                                                        |
| app_tracking_authorization_status | enum      | This field is only populated for iOS devices. Indicates the app tracking authorization status. This value is retrieved from ATTrackingManager and provided as is. For more information about iOS's app tracking authorization status, see this article. <br/><br/>**NOT_DETERMINED = 0** <br/>**RESTRICTED = 1** <br/>**DENIED = 2** <br/>**AUTHORIZED = 3**                                                                                                                                                 |
| connection_type                   | enum      | The type of network to which the user's device is connected. For 5G connection type, we send `CELL_4G` instead of `CELL_5G`. Default = **CONNECTION_UNKNOWN**. <br/><br/>**CONNECTION_UNKNOWN = 0** <br/>**ETHERNET = 1** <br/>**WIFI = 2** <br/>**CELL_UNKNOWN = 3** <br/>**CELL_2G = 4** <br/>**CELL_3G = 5** <br/>**CELL_4G = 6** <br/>**CELL_5G = 7**                                                                                                                                                    |

__OsVersion__

Contains the OS version of the platform. 
iOS 17.5.1 will be major = 17, minor = 5, micro = 1

| Attribute                   | Type  |
|-----------------------------|-------|
| major <br/>minor <br/>micro | int32 |

### IDFA support

#### Update Info.plist
Update your `Info.plist` to add the `NSUserTrackingUsageDescription` key with a custom message string describing your usage.
```
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
The usage description appears as part of the `App tracking transparency` dialog.

#### Request for `App tracking transparency`
- Link the `AppTrackingTransparency` framework:
Click on your project, open tab `General` for your app's target. Scroll down to `Frameworks, Libraries, and Embededd Content`, select `+` and add `App tracking transparency` framework.
Then inside your app, call `ATTrackingManager.requestTrackingAuthorization(completionHandler:)` to request permission.

If you want to `requestTrackingAuthorization` right after app launch, please follow this guide
- AppDelegate
Make the call inside `applicationDidBecomeActive`
```
func applicationDidBecomeActive(_ application: UIApplication) {
    // Just make sure this will be call on main thread
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if #available(iOS 14, *) {         
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
            })
        }
    }
}
```
- SceneDelegate
Make the call inside `sceneDidBecomeActive`
```
func sceneDidBecomeActive(_ scene: UIScene) {
    // Just make sure this will be call on main thread
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
            })
        }
    }
}
```


# About
Copyright 2024 Bridgewell | All Rights Reserved
