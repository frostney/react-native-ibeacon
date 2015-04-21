//
//  RNBeacon.m
//  RNBeacon
//
//  Created by Johannes Stein on 20.04.15.
//  Copyright (c) 2015 Geniux Consulting. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import "Beacon.h"

@interface Beacon() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation Beacon

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (instancetype)init
{
  if (self = [super init]) {
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
  }
  
  return self;
}

- (CLBeaconRegion *) createBeaconRegion: (NSString *) identifier uuid: (NSString *) uuid major: (NSInteger) major minor:(NSInteger) minor
{
  NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:uuid];
  
  unsigned short mj = (unsigned short) major;
  unsigned short mi = (unsigned short) minor;
  
  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:mj minor:mi identifier:identifier];
  
  return beaconRegion;
}

- (NSString *)stringForProximity:(CLProximity)proximity {
  switch (proximity) {
    case CLProximityUnknown:    return @"unknown";
    case CLProximityFar:        return @"far";
    case CLProximityNear:       return @"near";
    case CLProximityImmediate:  return @"immediate";
    default:
      return "";
  }
}


RCT_EXPORT_METHOD(requestAlwaysAuthorization)
{
  if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [self.locationManager requestAlwaysAuthorization];
  }
}

RCT_EXPORT_METHOD(requestWhenInUseAuthorization)
{
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
}

RCT_EXPORT_METHOD(startMonitoringForRegion: (NSString *) identifier uuid: (NSString *) uuid major: (NSInteger) major minor:(NSInteger) minor)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.locationManager startMonitoringForRegion:[self createBeaconRegion:identifier uuid:uuid major:major minor:minor]];
  });
}

RCT_EXPORT_METHOD(startRangingBeaconsInRegion: (NSString *) identifier uuid: (NSString *) uuid major: (NSInteger) major minor:(NSInteger) minor)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.locationManager startRangingBeaconsInRegion:[self createBeaconRegion:identifier uuid:uuid major:major minor:minor]];
  });
}

RCT_EXPORT_METHOD(stopMonitoringForRegion: (NSString *) identifier uuid: (NSString *) uuid major: (NSInteger) major minor:(NSInteger) minor)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.locationManager stopMonitoringForRegion:[self createBeaconRegion:identifier uuid:uuid major:major minor:minor]];
  });
}

RCT_EXPORT_METHOD(stopRangingBeaconsInRegion: (NSString *) identifier uuid: (NSString *) uuid major: (NSInteger) major minor:(NSInteger) minor)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.locationManager stopRangingBeaconsInRegion:[self createBeaconRegion:identifier uuid:uuid major:major minor:minor]];
  });
}

RCT_EXPORT_METHOD(startUpdatingLocation)
{
  [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location manager failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
  NSMutableArray *beaconArray = [[NSMutableArray alloc] init];
  
  for (CLBeacon *beacon in beacons) {
    [beaconArray addObject:@{
                             @"rssi": @(beacon.rssi),
                             @"proximity": [self stringForProximity: beacon.proximity]
                             }];
  }
  
  NSDictionary *event = @{
                          @"region": @{
                                @"identifier": region.identifier,
                                @"uuid": [region.proximityUUID UUIDString],
                                @"major": region.major,
                                @"minor": region.minor
                              },
                          @"beacons": beaconArray
                          };
  
  [self.bridge.eventDispatcher sendDeviceEventWithName:@"beaconsDidRange" body:event];
}

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
  NSDictionary *event = @{
                          @"region": region.identifier,
                          };
  
  [self.bridge.eventDispatcher sendDeviceEventWithName:@"regionDidEnter" body:event];
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
  NSDictionary *event = @{
                          @"region": region.identifier,
                          };
  
  [self.bridge.eventDispatcher sendDeviceEventWithName:@"regionDidExit" body:event];
}

@end
