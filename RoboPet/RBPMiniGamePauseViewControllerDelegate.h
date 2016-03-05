//
//  RBPMiniGamePauseViewControllerDelegate.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#ifndef RBPMiniGamePauseViewControllerDelegate_h
#define RBPMiniGamePauseViewControllerDelegate_h





@protocol RBPMiniGamePauseViewControllerDelegate <NSObject>

@required

- (void)pauseViewControllerDidSelectQuit;
- (void)pauseViewControllerDidSelectResume;
- (void)pauseViewControllerDidSelectPlayAgain;

@end






#endif /* RBPMiniGamePauseViewControllerDelegate_h */




