# react-native-ibeacon
iBeacon support for React Native

## Installation
Install using npm with `npm install --save react-native-ibeacon`

You then need to add the Objective C part to your XCode project. Drag `RNBeacon.xcodeproj` from the `node_modules/react-native-ibeacon` folder into your XCode project. Click on the your project in XCode, goto Build Phases then Link Binary With Libraries and add `libRNBeacon.a` and `CoreLocation.framework`.

NOTE: Make sure you don't have the `RNBeacon` project open seperately in XCode otherwise it won't work.

## Usage
```javascript
var Beacons = require('react-native-ibeacon');
```

## Code style guide
It uses theGeniux code style code, for more information see: https://github.com/geniuxconsulting/javascript

## License
MIT, for more information see `LICENSE`
