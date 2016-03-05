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

@end




