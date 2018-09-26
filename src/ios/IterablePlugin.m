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

- (void)deviceTokenIDRegister:(CDVInvokedUrlCommand *)command {

    NSString* setEmail = [command.arguments objectAtIndex:0];
    [[IterableAPI sharedInstance] setEmail:setEmail];

    NSData *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"iterableDeviceToken"];
    if(deviceToken != nil){
        [[IterableAPI sharedInstance] registerToken:deviceToken onSuccess:^(NSDictionary * _Nonnull data) {
              NSLog(@"registerToken request success response %@", data);
             CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
             [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } onFailure:^(NSString * _Nonnull reason, NSData * _Nullable data) {
              NSLog(@"registerToken request fail response %@", reason);
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"device token not found"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }else{
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"device token not found"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
  }


-(void)loadInAppMessage:(CDVInvokedUrlCommand *)command{
    [[IterableAPI sharedInstance] spawnInAppNotification:^(NSString *sucess){
         NSLog(@"test %@",sucess);
        }];
}

@end
