#import <Cordova/CDV.h>
#import "AppDelegate.h"

@interface IterablePlugin : CDVPlugin

+ (IterablePlugin *) iterablePlugin;
- (void)Init:(CDVInvokedUrlCommand *)command;
- (void)loadInAppMessage:(CDVInvokedUrlCommand *)command;
- (void)deviceTokenIDRegister:(CDVInvokedUrlCommand *)command;
@end
