//
//  RBPMiniGamePauseViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBPMiniGamePauseViewControllerDelegate.h"





@interface RBPMiniGamePauseViewController : UIViewController
{
}

@property (weak, nonatomic) id<RBPMiniGamePauseViewControllerDelegate> delegate;

@end




