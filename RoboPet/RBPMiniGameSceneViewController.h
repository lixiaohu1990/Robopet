//
//  RBPMiniGameSceneViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import UIKit;
@import SpriteKit;

#import "RBPBaseSceneViewController.h"

#import "RBPMiniGameScene.h"

#import "RBPMiniGameSceneViewControllerDelegate.h"
#import "RBPMiniGameTutorialViewController.h"
#import "RBPMiniGameTutorialPage.h"
#import "RBPMiniGameCountdownViewController.h"
#import "RBPMiniGamePopupViewController.h"





@interface RBPMiniGameSceneViewController : RBPBaseSceneViewController <RBPMiniGameSceneDelegate,
																		RBPMiniGamePopupViewControllerDelegate,
																		RBPMiniGameTutorialViewControllerDataSource>
{
}

@property (strong, nonatomic, readonly) UILabel *scoreLabel;
@property (weak, nonatomic) RBPMiniGameScene *minigame;

@property (weak, nonatomic) id<RBPMiniGameSceneViewControllerDelegate> delegate;

- (void)startMiniGame;
- (void)resumeMiniGame;

- (void)startCountdownViewController:(RBPMiniGameCountdownViewController *)viewController;
- (void)countdownViewControllerDidDismiss:(RBPMiniGameCountdownViewController *)viewController;

@end




