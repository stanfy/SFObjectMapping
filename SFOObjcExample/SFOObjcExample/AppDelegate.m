//
//  AppDelegate.m
//  SFOObjcExample
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationCore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [ApplicationCore setupMappingsForModelObjects];

    return YES;
}



@end
