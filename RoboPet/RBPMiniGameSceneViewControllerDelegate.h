//
//  RBPMiniGameSceneViewControllerDelegate.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#ifndef RBPMiniGameSceneViewControllerDelegate_h
#define RBPMiniGameSceneViewControllerDelegate_h

@class RBPMiniGameSceneViewController;





@protocol RBPMiniGameSceneViewControllerDelegate <NSObject>

@required

- (void)miniGameDidFinish:(RBPMiniGameSceneViewController *)miniGameViewController;

@end






#endif /* RBPMiniGameSceneViewControllerDelegate_h */




