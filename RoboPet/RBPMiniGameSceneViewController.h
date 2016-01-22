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





@interface RBPMiniGameSceneViewController : RBPBaseSceneViewController
{
}

@property (weak, nonatomic) id<RBPMiniGameSceneViewControllerDelegate> delegate;

@end




