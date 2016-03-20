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

/**
 *  Override in subclass
 *
 *  @return Class
 */
- (Class)sceneClass;

/**
 *  Override in subclass
 *
 *  @return NSString
 */
- (NSString *)backgroundImageName;

/**
 *  Array of SKTextures to preload
 *	Override in subclass
 *
 *  @return NSArray
 */
- (NSArray *)texturesToPreload;

@end




