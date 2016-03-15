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

@property (readwrite, nonatomic) BOOL currentPausedValue;
@property (strong, nonatomic) SKSpriteNode *backgroundImageNode;

@end





@implementation RBPBaseScene

#pragma mark - Init

- (void)didMoveToView:(SKView *)view
{
	[super didMoveToView:view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	[self restart];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	self.currentPausedValue = self.paused;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	self.paused = self.currentPausedValue;
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

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SKScene

//- (void)update:(CFTimeInterval)currentTime
//{
//}

@end




