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

- (RBPProgressView *)progressViewInternal
{
	return [RBPProgressView energyBar];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Roll class];
}

- (NSString *)backgroundImageName
{
	return @"roll_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




