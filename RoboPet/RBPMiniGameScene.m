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

@property (readwrite, nonatomic) CFTimeInterval runningTime;
// So we can calulate delta time
@property (readwrite, nonatomic) CFTimeInterval previousUpdateTime;

@end





@implementation RBPMiniGameScene

#pragma mark - Init

- (id)init
{
	self = [super init];
	
	if (self) {
		
	}
	
	return self;
}

- (void)initialize
{
	[super initialize ];
	
	self.previousUpdateTime = 0.0;
	self.runningTime = 0.0;
}

- (void)restart
{
	[super restart];
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
	[super update:currentTime];
	
	// Update the current running time
	if (self.previousUpdateTime != 0.0) {
		self.runningTime += currentTime - self.previousUpdateTime;
	}
	self.previousUpdateTime = currentTime;
}

- (void)setPaused:(BOOL)paused
{
	[super setPaused:paused];
	
	[self.progressView setProgress:self.progressView.progress animated:NO];
}

@end





