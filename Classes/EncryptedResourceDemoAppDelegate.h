//
//  EncryptedResourceDemoAppDelegate.h
//  EncryptedResourceDemo
//
//  Created by Robin Summerhill on 15/07/2010.
//  Copyright Aptogo Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EncryptedResourceDemoViewController;

@interface EncryptedResourceDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EncryptedResourceDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EncryptedResourceDemoViewController *viewController;

@end

