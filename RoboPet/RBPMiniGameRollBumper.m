//
//  RBPMiniGameRollBumper.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-16.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameRollBumper.h"





@interface RBPMiniGameRollBumper()

@end





@implementation RBPMiniGameRollBumper

#pragma mark - Init

- (id)init
{
	NSString *imageName = [NSString stringWithFormat:@"bumper_%d", (arc4random() % 2 == 0)];
	self = [super initWithTexture:[SKTexture textureWithImageNamed:imageName]];
	
	if (self) {
		
		CGFloat sizeScale = MAX(0.5, arc4random_uniform(115) / 100.0); // Random scale between x% and y%
		self.size = CGSizeMake(self.size.width * sizeScale, self.size.height * sizeScale);
		
		// Setup physics
		self.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:imageName] alphaThreshold:0.8 size:self.size];
		self.physicsBody.dynamic = NO;
		self.physicsBody.affectedByGravity = NO;
		
		[self removeFromParent];
		
	}
	
	return self;
}

#pragma mark - RBPMiniGameRollBumper

- (void)startRotating
{
	CGFloat randomDuration = MAX(1.0, arc4random_uniform(200) / 100.0); // Random duration between 1.0 and 2.0 seconds
	NSInteger angle = M_PI_2 * ((arc4random_uniform(2) == 1) ? 1 : -1);	// Random angle direction
	SKAction *rotateAction = [SKAction repeatActionForever:[SKAction rotateByAngle:angle duration:randomDuration]];
	
	[self runAction:rotateAction];
}

#pragma mark - Internal

- (void)removeFromParent
{
	[super removeFromParent];
	
	[self removeAllActions];
}

@end




