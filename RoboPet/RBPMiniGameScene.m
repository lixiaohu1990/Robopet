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

- (void)didMoveToView:(SKView *)view
{
	[super didMoveToView:view];
	
	[self initialize];
}

- (void)initialize
{
	
}

- (void)restart
{
	for (SKNode *node in self.children) {
		[node removeFromParent];
	}
	
	self.paused = NO;
	
	[self initialize];
}

@end





