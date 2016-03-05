//
//  RBPMiniGameSceneViewController_Jump.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Jump.h"

#import "RBPMiniGameScene_Jump.h"





@interface RBPMiniGameSceneViewController_Jump ()
{
}

@end





@implementation RBPMiniGameSceneViewController_Jump

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (RBPProgressView *)progressViewInternal
{
	return [RBPProgressView wellnessBar];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Jump class];
}

- (NSString *)backgroundImageName
{
	return @"jump_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




