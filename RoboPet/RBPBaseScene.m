//
//  RBPBaseScene.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPBaseScene.h"





@interface RBPBaseScene()
{
}

@property (strong, nonatomic) SKSpriteNode *backgroundImageNode;

@end





@implementation RBPBaseScene

#pragma mark - Init

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
		if (node != self.backgroundImageNode) {
			[node removeFromParent];
		}
	}
	
	self.paused = NO;
	
	[self initialize];
}

- (void)setBackgroundImageName:(NSString *)imageName
{
	if (self.backgroundImageNode) {
		[self.backgroundImageNode removeFromParent];
	}
	
	self.backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
	// Anchor top left corner
	self.backgroundImageNode.anchorPoint = CGPointZero;
	self.backgroundImageNode.position = CGPointZero;
	self.backgroundImageNode.size = self.size;
	
	[self addChild:self.backgroundImageNode];
}

#pragma mark - SKScene

//- (void)update:(CFTimeInterval)currentTime
//{
//}

@end




