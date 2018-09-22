#import "IterablePlugin.h"
#import <Cordova/CDV.h>
#import "AppDelegate.h"
#import "IterableAPI.h"

@implementation IterablePlugin

static IterablePlugin *iterablePlugin;

+ (IterablePlugin *) iterablePlugin {
    return iterablePlugin;
}

- (void)pluginInitialize {
    NSLog(@"Starting Firebase plugin");
    iterablePlugin = self;
}

- (void)Init:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)deviceRegister:(CDVInvokedUrlCommand *)command {
    NSString* setEmail = [command.arguments objectAtIndex:0];
    NSString* setUserId = [command.arguments objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    
    [[IterableAPI sharedInstance] setEmail:setEmail];
     if(setUserId.length > 0){
       [[IterableAPI sharedInstance] setUserId:setUserId];
    }
    
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"iterableDeviceToken"];
    [[IterableAPI sharedInstance] registerToken:deviceToken];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)loadInAppMessage:(CDVInvokedUrlCommand *)command{
    [[IterableAPI sharedInstance] spawnInAppNotification:^(NSString *sucess){
         NSLog(@"test %@",sucess);
        }];
}

@end
