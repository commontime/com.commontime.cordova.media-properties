//
//  CTMediaPropertiesPlugin
//  webrtc-plugin-test
//
//  Created by Gary Meehan on 21/06/2016.
//
//

#import "CTMediaPropertiesPlugin.h"

@implementation CTMediaPropertiesPlugin

- (void) getProperties: (CDVInvokedUrlCommand*) command
{
  @try
  {
    NSString* path = command.arguments[0];

    // TODO: get the properties
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
  }
  @catch (NSException *exception)
  {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                                                messageAsString: [exception reason]];
    
    [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
  }
}

@end