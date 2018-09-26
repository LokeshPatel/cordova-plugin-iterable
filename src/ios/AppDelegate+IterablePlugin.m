#import "AppDelegate+IterablePlugin.h"
#import "IterablePlugin.h"
#import <objc/runtime.h>
#import "IterableAPI.h"

@implementation AppDelegate (IterablePlugin)

+ (void)load {
    Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    Method swizzled = class_getInstanceMethod(self, @selector(application:interableSwizzledDidFinishLaunchingWithOptions:));
    method_exchangeImplementations(original, swizzled);
}

- (BOOL)application:(UIApplication *)application interableSwizzledDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application interableSwizzledDidFinishLaunchingWithOptions:launchOptions];
    // Initialize Iterable SDK
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Run your loop here
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //stop your HUD here
            //This is run on the main thread
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"www/iterableconfig" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSError *error;
            NSDictionary *iterableconfig = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             if (error) {
                 NSLog(@"Something went wrong! %@", error.localizedDescription);
              }else {
                NSLog(@"party info: %@", iterableconfig);
                IterableConfig *config = [[IterableConfig alloc] init];
                if([iterableconfig valueForKey:@"ios"]){
                 config.pushIntegrationName = [[iterableconfig valueForKey:@"ios"] valueForKey:@"pushIntegrationName"];
                 config.sandboxPushIntegrationName = [[iterableconfig valueForKey:@"ios"] valueForKey:@"sandboxPushIntegrationName"];
                    [IterableAPI initializeWithApiKey:[[iterableconfig valueForKey:@"ios"] valueForKey:@"initializeWithApiKey"] launchOptions:launchOptions config:config];
                }
            }
        });
    });
    return YES;
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"iterableDeviceToken"];
}

@end
