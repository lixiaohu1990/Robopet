//
//  RBPMiniGamePauseViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGamePopupViewController.h"

@class RBPProgressView;

#define PADDING 20.0





@interface RBPMiniGamePauseViewController : RBPMiniGamePopupViewController
{
}

@property (strong, nonatomic) RBPProgressView *wellnessBar;
@property (strong, nonatomic) RBPProgressView *happinessBar;
@property (strong, nonatomic) RBPProgressView *energyBar;

@property (strong, nonatomic) UIButton *soundButton;

@end




