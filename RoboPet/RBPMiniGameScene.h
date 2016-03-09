//
//  RBPMiniGameScene.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPBaseScene.h"

#import "RBPProgressView.h"





@interface RBPMiniGameScene : RBPBaseScene
{
}

/**
 *  The time in seconds since the mini game has been playing
 *	Does not increment when paused
 */
@property (readonly, nonatomic) CFTimeInterval runningTime;

@property (weak, nonatomic) RBPProgressView *progressView;

@end




