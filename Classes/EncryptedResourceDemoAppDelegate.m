//
//  EncryptedResourceDemoAppDelegate.m
//  EncryptedResourceDemo
//
//  Created by Robin Summerhill on 15/07/2010.
//  Copyright Aptogo Ltd 2010. All rights reserved.
//

#import "EncryptedResourceDemoAppDelegate.h"
#import "EncryptedResourceDemoViewController.h"
#import "EncryptedFileURLProtocol.h"

@implementation EncryptedResourceDemoAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    
    
    //window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Add the view controller's view to the window and display.
   // [window addSubview:viewController.view];
     [window setRootViewController:viewController ];
    [window makeKeyAndVisible];

    // Register the custom URL protocol with the URL loading system
    [NSURLProtocol registerClass:[EncryptedFileURLProtocol class]];
    
    return YES;
}

@end
