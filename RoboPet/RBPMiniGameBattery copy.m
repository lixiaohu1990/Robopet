//
//  RBPMiniGameBattery.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-16.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameBattery.h"





@interface RBPMiniGameBattery()

@property (strong, nonatomic) SKSpriteNode *battery;
@property (strong, nonatomic) SKSpriteNode *batteryFill;

@property (nonatomic, readwrite) CGFloat chargePercentage;

@end





@implementation RBPMiniGameBattery

#pragma mark - Init

- (id)init
{
	self = [super init];
	
	if (self) {
		
		self.chargePercentage = 1.0;
		
		self.battery = [SKSpriteNode spriteNodeWithImageNamed:@"battery"];
		self.battery.anchorPoint = CGPointMake(0.0, 0.5);
		self.size = self.battery.size;
		
		self.batteryFill = [[SKSpriteNode alloc] init];
		self.batteryFill.anchorPoint = CGPointMake(0.0, 0.5);
		
		[self addChild:self.battery];
		[self addChild:self.batteryFill];
		
		[self removeFromParent];
		
	}
	
	return self;
}

#pragma mark - RBPMiniGameBattery

- (CGFloat)chargePercentage
{
	CGFloat percentage = self.batteryFill.size.width / self.battery.size.width;
	return percentage;
}

- (BOOL)isDraining
{
	return [self.batteryFill hasActions];
}

- (void)startDrainWithDuration:(CGFloat)duration completion:(void (^)(RBPMiniGameBattery *battery))completion
{
	if (![self isDraining]) {
		
		SKAction *scaleAction = [SKAction resizeToWidth:0.0 duration:duration];
		
		SKAction *colorAction1 = [SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1.0 duration:duration * 0.5];
		SKAction *colorAction2 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0 duration:duration * 0.5];
		SKAction *colorSequence = [SKAction sequence:@[colorAction1, colorAction2]];
		
		[self.batteryFill runAction:[SKAction group:@[scaleAction, colorSequence]] completion:^{
			if (completion) {
				completion(self);
			}
		}];
		
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
	
	self.battery.size = size;
	self.batteryFill.size = size;
}

- (BOOL)intersectsNode:(SKNode *)node
{
	return [self.battery intersectsNode:node];
}

@end




