//
//  RBPMiniGameRollBattery.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-16.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import SpriteKit;





@interface RBPMiniGameRollBattery : SKSpriteNode
{
}

@property (nonatomic, readonly) CGFloat chargePercentage;
@property (nonatomic, readonly) BOOL isDraining;

- (void)startDrainWithDuration:(CGFloat)duration completion:(void (^)(RBPMiniGameRollBattery *battery))completion;

@end




