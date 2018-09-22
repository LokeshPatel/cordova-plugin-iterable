#import <Cordova/CDV.h>
#import "AppDelegate.h"

@interface IterablePlugin : CDVPlugin

+ (IterablePlugin *) iterablePlugin;
- (void)Init:(CDVInvokedUrlCommand *)command;
- (void)deviceRegister:(CDVInvokedUrlCommand *)command;
- (void)loadInAppMessage:(CDVInvokedUrlCommand *)command;

@end
