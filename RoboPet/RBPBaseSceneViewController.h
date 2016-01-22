//
//  RBPBaseSceneViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import UIKit;
@import SpriteKit;

#import "RBPBaseSceneViewController.h"





@interface RBPBaseSceneViewController : UIViewController
{
}

@property (strong, nonatomic) SKView *view;

- (Class)sceneClass;

@end




