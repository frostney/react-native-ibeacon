//
//  RNBeacon.h
//  RNBeacon
//
//  Created by Johannes Stein on 20.04.15.
//  Copyright (c) 2015 Geniux Consulting. All rights reserved.
//

#if __has_include(<React/RCTBridgeModule.h>)

#import <React/RCTBridgeModule.h>

#else

#import "RCTBridgeModule.h"

#endif

@interface RNBeacon : NSObject <RCTBridgeModule>

@end
