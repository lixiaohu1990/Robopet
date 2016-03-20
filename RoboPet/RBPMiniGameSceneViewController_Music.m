//
//  RBPMiniGameSceneViewController_Music.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Music.h"

#import "RBPMiniGameScene_Music.h"

#import "RBPMiniGameTutorialViewController.h"





@interface RBPMiniGameSceneViewController_Music ()
{
}

@end



@implementation RBPMiniGameSceneViewController_Music

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Music class];
}

- (NSString *)backgroundImageName
{
	return @"music_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (UIScrollView *)tutorialScrollView;
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RBPMiniGameMusic_TutorialPages" owner:nil options:nil] firstObject];
}

@end




