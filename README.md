# SygicMaps SDK examples for iOS

Add navigation features to your app with SygicMaps framework. Examples are provided as an addition to [documentation](https://developers.sygic.com/maps-sdk/ios/getting_started/).

## Structure

Each folder contains an iOS application project. Projects are independent from each other.

1. SygicStart - show the map (corresponds to [Getting Started](https://developers.sygic.com/maps-sdk/ios/getting_started/))
1. BasicRouting - calculate a route, show it on map (corresponds to [Routing](https://developers.sygic.com/maps-sdk/ios/routing/))

## How to run

1. Install CocoaPods
1. Clone this repository
1. From Terminal, go to SygicStart directory `cd /your/path/to/sygic-sdk-examples-ios/SygicStart`
1. From Terminal, install CocoaPods dependencies using `pod install`
1. Open SygicStart.xcworkspace
1. Set your Apple Development signing identity
1. Build the project (at the very first time it will fail because API key is not set yet)
1. Fix the error in NoCommitConstants.swift by specifying your [Sygic API key](https://www.sygic.com/enterprise/get-api-key) (this file is shared between all projects)
1. Build and run the application

Similar approach is valid for each folder with demo project. 
