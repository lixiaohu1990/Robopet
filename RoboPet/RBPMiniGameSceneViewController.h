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

#import "RBPMiniGameSceneViewControllerDelegate.h"
#import "RBPMiniGameTutorialViewController.h"
#import "RBPMiniGameTutorialPage.h"
#import "RBPMiniGamePopupViewController.h"

#import "RBPProgressView.h"





@interface RBPMiniGameSceneViewController : RBPBaseSceneViewController <RBPMiniGamePopupViewControllerDelegate,
																		RBPMiniGameTutorialViewControllerDataSource,
																		RBPProgressViewDelegate>
{
}


@property (weak, nonatomic) id<RBPMiniGameSceneViewControllerDelegate> delegate;


/**
 *  The progress view for this mini games level
 */
@property (strong, nonatomic) RBPProgressView *progressView;


/**
 *  Called before mini game will start/restart
 */
- (void)miniGameWillStart;
/**
 *  Called when resuming minigame from Pause menu
 */
- (void)miniGameWillResume;
/**
 *  Call this when mini game has ended (game over)
 */
- (void)miniGameDidFinish;

@end




