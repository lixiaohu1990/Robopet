//
//  RBPMiniGameScene.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameScene.h"

#import "RBPProgressView.h"





@interface RBPMiniGameScene()
{
}

@end





@implementation RBPMiniGameScene

#pragma mark - Init

- (void)initialize
{
}

- (void)restart
{
	[super restart];
}

#pragma mark - SKScene

- (void)setPaused:(BOOL)paused
{
	[super setPaused:paused];
	
	[self.progressView setProgress:self.progressView.progress animated:NO];
}

@end





