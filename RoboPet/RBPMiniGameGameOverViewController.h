//
//  RBPMiniGameGameOverViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGamePauseViewController.h"

@class RBPMiniGameScene;




@interface RBPMiniGameGameOverViewController : RBPMiniGamePauseViewController
{
}

- (id)initWithMiniGame:(RBPMiniGameScene *)miniGame;

/**
 *  Update the score text
 *
 *  @param animated
 *  @param completion 
 */
- (void)updateScoresAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
/**
 *  Update the progress bar to the current minigames score
 *
 *  @param progressView
 *  @param animated
 */
- (void)updateProgressViewAnimated:(BOOL)animated;

@end




