//
//  RBPMiniGameScene.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPBaseScene.h"

#import "RBPProgressView.h"

@class RBPMiniGameScene;





@protocol RBPMiniGameSceneDelegate <NSObject>

@required

- (void)onMiniGameScoreChange:(RBPMiniGameScene *)miniGame;
- (void)onMiniGameGameOver:(RBPMiniGameScene *)miniGame;

@end





@interface RBPMiniGameScene : RBPBaseScene
{
}

@property (weak, nonatomic) id<RBPMiniGameSceneDelegate> minigameDelegate;

/**
 *  Defaults to 1
 */
@property (readwrite, nonatomic) NSUInteger difficultyLevel;

/**
 *  Score
 */
@property (readwrite, nonatomic) CGFloat score;

/**
 *  The time in seconds since the mini game has been playing
 *	Does not increment when paused
 */
@property (readonly, nonatomic) CFTimeInterval runningTime;

@end




