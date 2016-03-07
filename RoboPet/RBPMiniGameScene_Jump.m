//
//  RBPMiniGameScene_Jump.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameScene_Jump.h"





@interface RBPMiniGameScene_Jump()
{
}

@property (strong, nonatomic) SKSpriteNode *ground1;

@end





@implementation RBPMiniGameScene_Jump

#pragma mark - Init

- (void)initialize
{
	[super initialize];
	
	// Setup view here
	
	
//	self.ground1 = [SKSpriteNode spriteNodeWithImageNamed:@"jump_ground"];
//	self.ground1.anchorPoint = CGPointZero;
//	self.ground1.size = CGSizeMake(self.size.width, self.ground1.size.height);
//	[self addChild:self.ground1];
}

- (void)restart
{
	[super restart];
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
}

@end




