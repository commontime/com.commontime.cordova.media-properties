//
//  CTMediaPropertiesPlugin
//  webrtc-plugin-test
//
//  Created by Gary Meehan on 21/06/2016.
//
//

#import "CTMediaPropertiesPlugin.h"

#import "CDVFile.h"

#import <AVFoundation/AVFoundation.h>

@implementation CTMediaPropertiesPlugin

- (void) getProperties: (CDVInvokedUrlCommand*) command
{
  @try
  {
    NSString* path = command.arguments[0];
    NSURL* URL = nil;
    
    if ([path hasPrefix: @"file://"])
    {
      URL = [NSURL URLWithString: path];
    }
    else if ([path hasPrefix: @"cdvfile://"])
    {
      CDVFile* filePlugin = [[CDVFile alloc] init];
      
      [filePlugin pluginInitialize];
      
      CDVFilesystemURL* cdvURL = [CDVFilesystemURL fileSystemURLWithString: path];
      NSString* filePath = [filePlugin filesystemPathForURL: cdvURL];
      
      URL = [NSURL fileURLWithPath: filePath];
    }
    else
    {
      URL = [NSURL fileURLWithPath: path];
    }
    
    if (!URL)
    {
      CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                                                  messageAsString: @"invalid path or URL"];
      
      [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];

      return;
    }
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL: URL options: nil];

    [asset loadValuesAsynchronouslyForKeys: @[@"duration"] completionHandler: ^{
      NSError *error = nil;
      AVKeyValueStatus status = [asset statusOfValueForKey: @"duration" error: &error];
      
      switch (status)
      {
        case AVKeyValueStatusLoaded:
        {
          NSDictionary* properties = @{ @"duration" : @(asset.duration.value/asset.duration.timescale) };
          
          CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                                  messageAsDictionary: properties];
          
          [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
          
          break;
        }
        default:
        {
          CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                                                      messageAsString: [error localizedDescription]];
          
          [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
          
          break;
        }
      }
    }];
  }
  @catch (NSException *exception)
  {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                                                messageAsString: [exception reason]];
    
    [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
  }
}

@end