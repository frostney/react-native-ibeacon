/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NativeModules,
  DeviceEventEmitter
} = React;

var bleacons = {
  "identifier": "id-5",
  "uuid": "73676723-7400-0000-FFFF-0000FFFF0005",
  "minor": 670,
  "major": 2
};

var Bacon = NativeModules.Beacon;

Bacon.requestAlwaysAuthorization();
Bacon.startMonitoringForRegion(bleacons.identifier, bleacons.uuid, bleacons.major, bleacons.minor);
Bacon.startRangingBeaconsInRegion(bleacons.identifier, bleacons.uuid, bleacons.major, bleacons.minor);

Bacon.startUpdatingLocation();

var subscription = DeviceEventEmitter.addListener(
  'beaconsDidRange',
  (data) => alert(JSON.stringify(data))
);

var RNBeacon = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+Control+Z for dev menu
        </Text>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('RNBeacon', () => RNBeacon);
