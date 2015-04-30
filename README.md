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
  	//	  .rssi - Signal strength: RSSI value (between -100 and 0)
  	// 	  .proximity - Proximity value, can either be "unknown", "far", "near" or "immediate"
  	//	  .accuracy - The accuracy of a beacon
  }
);
```

It is recommended to set `NSWhenInUseUsageDescription` in your `Info.plist` file.

## Background mode
For background mode to work, a few things need to be configured:
In the Xcode project, go to Capabilities, switch on "Background Modes" and check both "Location updates" and "Uses Bluetooth LE accessories".


Then, instead of using `requestWhenInUseAuthorization` the method `requestAlwaysAuthorization`.
```javascript
Beacons.requestAlwaysAuthorization();
```

Here, it's also recommended to set `NSLocationAlwaysUsageDescription` in your `Info.plist` file.

## Events
To listen to events we need to call `DeviceEventEmitter.addListener` (`var {DeviceEventEmitter} = require('react-native')`) where the first parameter is the event we want to listen to and the second is a callback function that will be called once the event is triggered.

### beaconsDidRange
This event will be called for every region in every beacon interval. If you have three regions you get three events every second (which is the default interval beacons send their signal).
When we take a closer look at the parameter of the callback, we get information on both the region and the beacons.
```javascript
{
  region: {
    identifier: String,
    uuid: String
  },
  beacons: Array<Beacon>
}
```

A `Beacon` is an object that follows this structure:
```javascript
{
  uuid: String, // The uuid for the beacon
  major: Number, // A beacon's major value
  minor: Number, // A beacon's minor value
  rssi: Number, // The signal strength, where -100 is the maximum value and 0 the minium. 
                // If the value is 0, this corresponds to not being able to get a precise value
  proximity: String, // Fuzzy value representation of the signal strength.
  		     // Can either be "far", "near", "immediate" or "unknown"
  accuracy: Number // A calculated distance value from the device to the beacon
}
```

### regionDidEnter
If the device entered a region, `regionDidEnter` is being called.

Inside the callback the paramter we can use returns an object with a property `region` that contains the region identifier value as a string.
```javascript
{
  region: String
}
```

### regionDidExit
In the same `regionDidEnter` is called if the device entered a region, `regionDidExit` will be called if the device exited a region and we can't get any signal from any of the beacons inside the region.

As for the payload, we get a property called `region` that represents the region identifier and is a string.
```javascript
{
  region: String
}
```

## Troubleshooting

### In the `beaconsDidRange` event, the `beacons` property is just an empty array.
There are several things that trigger that behavior, so it's best to follow these steps:

1. Don't use the same identifier for multiple regions
2. Check if your beacon batteries aren't empty
3. If monitoring and ranging for beacons, make sure to first monitor and then range

## Code style guide
It uses the Geniux code style guide, for more information see: https://github.com/geniuxconsulting/javascript

## License
MIT, for more information see `LICENSE`
