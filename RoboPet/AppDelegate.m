//
//  AppDelegate.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import SpriteKit;

#import "AppDelegate.h"

#import "RBPProgressView.h"

#define LAST_EXIT_DATE_DEFAULTS_KEY @"RBPAppDidExitDefaultsKey"





@interface AppDelegate ()

@end





@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Store date
	[[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:LAST_EXIT_DATE_DEFAULTS_KEY];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] valueForKey:LAST_EXIT_DATE_DEFAULTS_KEY];
	
	if (lastDate) {
		
		NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:lastDate];
		
		CGFloat levelDecreasePercentage = time / 86400; // 86400 seconds in a day
		levelDecreasePercentage = MAX(0.0, MIN(1.0, levelDecreasePercentage)); // Clamp between 0.0 and 1.0 (%)
		
		NSLog(@"wellnessProgress: %f", [RBPProgressView wellnessProgress]);
		NSLog(@"happinessProgress: %f", [RBPProgressView happinessProgress]);
		NSLog(@"energyProgress: %f", [RBPProgressView energyProgress]);
		
		[RBPProgressView setWellnessProgress:[RBPProgressView wellnessProgress] - levelDecreasePercentage];
		[RBPProgressView setHappinessProgress:[RBPProgressView happinessProgress] - levelDecreasePercentage];
		[RBPProgressView setEnergyProgress:[RBPProgressView energyProgress] - levelDecreasePercentage];
		
		NSLog(@"Time between last app activity %@", @(time));
		NSLog(@"Decrease percentage %f% %@", levelDecreasePercentage);
		
		NSLog(@"wellnessProgress: %f", [RBPProgressView wellnessProgress]);
		NSLog(@"happinessProgress: %f", [RBPProgressView happinessProgress]);
		NSLog(@"energyProgress: %f", [RBPProgressView energyProgress]);
		
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self applicationWillEnterForeground:application];
}

@end
