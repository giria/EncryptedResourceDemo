//
//  main.m
//  EncryptedResourceDemo
//
//  Created by Robin Summerhill on 15/07/2010.
//  Copyright Aptogo Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EncryptedResourceDemoAppDelegate.h"


int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([EncryptedResourceDemoAppDelegate class]));
    [pool release];
    return retVal;
}
