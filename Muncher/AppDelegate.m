//
//  AppDelegate.m
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "AppDelegate.h"
#import "Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"tc6OGywzNcYXbGPdczxTWdq8yi942HWpTSTbtftI"
                  clientKey:@"RejBqE8K7uZBz6jPDVR1VySJV17xtPVN9fMV468l"];
    
    // Testing purposes to log out the user
    [PFUser logOut];
    
    // Login capability with Parse's Anonymous Users
    if (![PFUser currentUser]) {
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Anonymous login failed.");
            } else {
                NSLog(@"Anonymous user logged in.");
            }
        }];
    }
    return YES;
}



@end
