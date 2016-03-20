//
//  RBPSoundManager.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPSoundManager.h"





@implementation RBPSoundManager

#pragma mark - RBPSoundManager

+ (BOOL)soundEnabled
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"soundEnabled": @(YES), }];
	
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEnabled"];
}

+ (void)setSoundEnabled:(BOOL)soundEnabled
{
	[[NSUserDefaults standardUserDefaults] setBool:soundEnabled forKey:@"soundEnabled"];
}

+ (void)runSoundAction:(SKAction *)action onNode:(SKNode *)node
{
	if ([RBPSoundManager soundEnabled]) {
		[node runAction:action];
	}
}

@end




