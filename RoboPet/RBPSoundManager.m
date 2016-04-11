//
//  RBPSoundManager.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPSoundManager.h"

#define SOUND_ENABLED_DEFAULTS_KEY @"RBPSoundEnabledDefaultsKey"





@implementation RBPSoundManager

#pragma mark - RBPSoundManager

+ (BOOL)soundEnabled
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{ SOUND_ENABLED_DEFAULTS_KEY: @(YES), }];
	
	return [[NSUserDefaults standardUserDefaults] boolForKey:SOUND_ENABLED_DEFAULTS_KEY];
}

+ (void)setSoundEnabled:(BOOL)soundEnabled
{
	[[NSUserDefaults standardUserDefaults] setBool:soundEnabled forKey:SOUND_ENABLED_DEFAULTS_KEY];
}

+ (void)runSoundAction:(SKAction *)action onNode:(SKNode *)node completion:(void (^)())completion
{
	if ([RBPSoundManager soundEnabled]) {
		[node runAction:action completion:completion];
	} else {
		if (completion) {
			completion();
		}
	}
}

@end




