//
//  CTMediaPropertiesPlugin
//  webrtc-plugin-test
//
//  Created by Gary Meehan on 21/06/2016.
//
//

#import <Foundation/Foundation.h>

#import <Cordova/CDV.h>

@interface CTMediaPropertiesPlugin : CDVPlugin

- (void) getProperties: (CDVInvokedUrlCommand*) command;

@end