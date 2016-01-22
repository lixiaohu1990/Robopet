//
//  RBPMiniGameSceneViewController_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Roll.h"

#import "RBPMiniGameScene_Roll.h"





@interface RBPMiniGameSceneViewController_Roll ()
{
}

@end





@implementation RBPMiniGameSceneViewController_Roll

@dynamic view;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Roll class];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




