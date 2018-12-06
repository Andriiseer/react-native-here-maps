[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

# HERE Maps React-Native IOS Map/Route/Turn-by-Turn Navigation

 <center>Routing | Navigation
------------ | -------------
![](https://media.giphy.com/media/bbORXxwGhb7BWTHPF3/giphy.gif)   | ![](https://media.giphy.com/media/4TrIodkaHvxts0KY4l/giphy.gif)
</center>
Copyright (c) 2011-2018 HERE Europe B.V.

> **Note:** In order to get the sample code to work, you **must** replace all instances of `{YOUR_APP_ID}`, `{YOUR_APP_CODE}` and `{YOUR_LICENSE_KEY}` within the code and use your own **HERE** credentials.

> You can obtain a set of credentials from the [Contact Us](https://developer.here.com/contact-us) page on developer.here.com.**The bundle ID registered must match it in your app**.

THIS MODULE CURRENTLY WORKS ON IOS ONLY, ANDROID VERSION IS STILL IN DEVELOPMENT. 

## iOS Install


1. Add `pod 'HEREMaps', '>= 3.8'` to your Podfile in IOS directory. Run ' cd ios' and 'pod install'.

2. Add bridging file HRMap.js to your project directory.

3. In XCode project Add HRMapManager.m, HRMapView.h, HRMapView.m using Add Files to "**project-name**".

4. In Build Phases of your project add NMAKit.framework from ios/Pods/HEREMaps/Framework.

5. Select an eligible provisioning profile or enable "Automatically manage signing" in General settings of the App target.

6. Put corresponding to your HereMapsSDK credentials Bundle Identifier into General settings of the App target.

7. In `AppDelegate.m`:
    - Enter an app id, app code and license key.
    
8. Import `NativeModules` from "React-Native" and import MainHRMap from 'HRMap.js'. 

9. Render the map using <MainHRMap> tag. (Dont forget to add width and height to the map as well as Initial coordinates)
    

## Running the example project

1. Download the project. 

2. Run `npm install` in project directory.

3. Run `cd ios` and `pod install`.

4. Open the `heremapsexample.xcworkspace` file from ios directory. 

5. In `AppDelegate.m`:
    - Enter your app id, app code and license key.
6. In `General` settings to your project put your Bundle identifier corresponding to your HERE credentials.

7. Run the project on simulator or device.



## Build Requirements
 
* Xcode 8 & iOS 9 SDK or above
* CRNA or Expokit Detached React Native Project. 
* WILL NOT work if you try to use in within Expo project since it does not support native modules.

## Target Platform
 
* iOS 10.0 and above

