//
//  RBPMiniGameRollBattery.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-16.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameRollBattery.h"





@interface RBPMiniGameRollBattery()

//@property (strong, nonatomic) SKSpriteNode *battery;
@property (strong, nonatomic) SKSpriteNode *batteryFill;

@end





@implementation RBPMiniGameRollBattery

#pragma mark - Init

- (id)init
{
	self = [super initWithTexture:[SKTexture textureWithImageNamed:@"battery"]];
	
	if (self) {
		
		self.batteryFill = [[SKSpriteNode alloc] init];
		// Anchor to left for drain action
		self.batteryFill.anchorPoint = CGPointMake(0.0, 0.5);
		
		[self addChild:self.batteryFill];
		
		[self removeFromParent];
		
	}
	
	return self;
}

#pragma mark - RBPMiniGameRollBattery

- (CGFloat)chargePercentage
{
	CGFloat percentage = self.batteryFill.size.width / self.size.width;
	return percentage;
}

static NSString *batteryDrainActionKey = @"batteryDrainActionKey";

- (BOOL)isDraining
{
	return [self.batteryFill actionForKey:batteryDrainActionKey];
}

- (void)startDrainWithDuration:(CGFloat)duration completion:(void (^)(RBPMiniGameRollBattery *battery))completion
{
	if (![self isDraining]) {
		
		SKAction *scaleAction = [SKAction resizeToWidth:0.0 duration:duration];
		
		SKAction *colorAction1 = [SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1.0 duration:duration * 0.5];
		SKAction *colorAction2 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0 duration:duration * 0.5];
		SKAction *colorSequence = [SKAction sequence:@[colorAction1, colorAction2]];
		
		
		SKAction *actionCompletion = [SKAction runBlock:^{
			if (completion) {
				completion(self);
			}
		}];
		
		// run the action and color sequence together, then the completion action
		[self.batteryFill runAction:[SKAction sequence:@[[SKAction group:@[scaleAction, colorSequence]],
											 actionCompletion]] withKey:batteryDrainActionKey];
		
	}
}

#pragma mark - Internal

- (void)reset
{
	[self.batteryFill removeAllActions];
	
	self.batteryFill.color = [UIColor greenColor];
	self.batteryFill.size = self.size;
}

- (void)removeFromParent
{
	[super removeFromParent];
	
	[self reset];
}

- (void)setSize:(CGSize)size
{
	[super setSize:size];
	
	self.batteryFill.size = size;
	[self.batteryFill runAction:[SKAction moveByX:-(self.size.width * 0.5) y:0.0 duration:0.0]];
}

@end




