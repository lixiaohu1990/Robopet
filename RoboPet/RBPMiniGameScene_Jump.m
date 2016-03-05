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

@end





@implementation RBPMiniGameScene_Jump

#pragma mark - SKScene

- (void)initialize
{
	[super initialize];

    // Setup view here
    
    SKLabelNode *label = [SKLabelNode labelNodeWithText:@"Jump Mini Game"];
    label.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:label];
}

- (void)update:(CFTimeInterval)currentTime
{
}

@end




