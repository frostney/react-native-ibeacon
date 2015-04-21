# react-native-ibeacon
iBeacon support for React Native. The API is very similar to the CoreLocation Objective-C one with the only major difference that regions are plain JavaScript objects.
Beacons don't work in the iOS simulator.

## Installation
Install using npm with `npm install --save react-native-ibeacon`

You then need to add the Objective C part to your XCode project. Drag `RNBeacon.xcodeproj` from the `node_modules/react-native-ibeacon` folder into your XCode project. Click on the your project in XCode, goto Build Phases then Link Binary With Libraries and add `libRNBeacon.a` and `CoreLocation.framework`.

NOTE: Make sure you don't have the `RNBeacon` project open seperately in XCode otherwise it won't work.

## Usage
```javascript
var React = require('react-native');
var {DeviceEventEmitter} = React;

var Beacons = require('react-native-ibeacon');

// Define a region which can be identifier + uuid, 
// identifier + uuid + major or identifier + uuid + major + minor
// (minor and major properties are numbers)
var region = {
	identifier: 'Estimotes',
	uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'	
};

// Request for authorization while the app is open
Beacons.requestWhenInUseAuthorization();

Beacons.startMonitoringForRegion(region);
Beacons.startRangingBeaconsInRegion(region);

Beacons.startUpdatingLocation();

// Listen for beacon changes
var subscription = DeviceEventEmitter.addListener(
  'beaconsDidRange',
  (data) => {
  	// data.region - The current region
  	// data.region.identifier
  	// data.region.uuid

  	// data.beacons - Array of all beacons inside a region
  	//	in the following structure:
  	//	  .uuid
  	//	  .major - The major version of a beacon
  	//	  .minor - The minor version of a beacon
  	//	  .rssi - RSSI value (between -100 and 0)
  	// 	  .proximity - Proximity value, can either be "unknown", "far", "near" or "immediate"
  	//	  .accuracy - The accuracy of a beacon
  }
);
```

It is recommended to set in `NSWhenInUseUsageDescription` in your `Info.plist` file.

## Background mode
For background mode to work, a few things need to be configured:
In your Xcode project, go to Capabilities, switch on "Background Modes" and check both "Location updates" and "Uses Bluetooth LE accessories".


Then, instead of using `requestWhenInUseAuthorization` the method `requestAlwaysAuthorization`.
```javascript
Beacons.requestAlwaysAuthorization();
```

Here, it's also recommended to set `NSLocationAlwaysUsageDescription` in your `Info.plist` file.

## Code style guide
It uses the Geniux code style guide, for more information see: https://github.com/geniuxconsulting/javascript

## License
MIT, for more information see `LICENSE`
