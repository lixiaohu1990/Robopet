//
//  RBPMiniGameRollBattery.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-16.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameRollBattery.h"

#define BATTERY_WIDTH 115





@interface RBPMiniGameRollBattery()

@property (strong, nonatomic) SKSpriteNode *batteryNegativeEnd;
@property (strong, nonatomic) SKSpriteNode *batteryFill;
@property (strong, nonatomic) SKSpriteNode *batteryPositiveEnd;
@property (strong, nonatomic) SKSpriteNode *batteryIcon;

@end





@implementation RBPMiniGameRollBattery

#pragma mark - Init

- (id)init
{
	self = [super initWithTexture:[SKTexture textureWithImageNamed:@"battery_body"]];
	
	if (self) {
		
		self.size = CGSizeMake(BATTERY_WIDTH, self.size.height);
		
		
		self.batteryNegativeEnd = [SKSpriteNode spriteNodeWithImageNamed:@"battery_negative_end"];
		self.batteryNegativeEnd.anchorPoint = CGPointMake(1.0, 0.5);
		[self addChild:self.batteryNegativeEnd];
		
		self.batteryFill = [SKSpriteNode spriteNodeWithImageNamed:@"battery_body"];
		self.batteryFill.anchorPoint = CGPointMake(0.0, 0.5); // Anchor to left for drain action
		[self addChild:self.batteryFill];
		
		self.batteryPositiveEnd = [SKSpriteNode spriteNodeWithImageNamed:@"battery_positive_end"];
		self.batteryPositiveEnd.anchorPoint = CGPointMake(0.0, 0.5);
		[self addChild:self.batteryPositiveEnd];
		
		self.batteryIcon = [SKSpriteNode spriteNodeWithImageNamed:@"battery_icon"];
		[self addChild:self.batteryIcon];
		
		
		[self reset];
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
	return ([self.batteryFill actionForKey:batteryDrainActionKey] != nil);
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
	
	CGFloat halfWidth = self.size.width * 0.5;
	
	// Align all battery parts
	
	[self.batteryNegativeEnd runAction:[SKAction moveToX:-halfWidth duration:0.0]];
	
	[self.batteryFill runAction:[SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1.0 duration:0.0]];
	self.batteryFill.size = self.size;
	[self.batteryFill runAction:[SKAction moveToX:-halfWidth duration:0.0]];
	
	[self.batteryPositiveEnd runAction:[SKAction moveToX:halfWidth duration:0.0]];
	
	[self.batteryIcon runAction:[SKAction moveToX:halfWidth * 0.5 duration:0.0]];
}

- (void)removeFromParent
{
	[super removeFromParent];
	
	[self reset];
}

- (void)setSize:(CGSize)size
{
	[super setSize:size];
	
	[self reset];
}

- (BOOL)intersectsNode:(SKNode *)node
{
	return ([super intersectsNode:node] || [self.batteryNegativeEnd intersectsNode:node] || [self.batteryPositiveEnd intersectsNode:node]);
}

@end




