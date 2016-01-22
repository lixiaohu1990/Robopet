//
//  RBPMiniGameSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController.h"





@interface RBPMiniGameSceneViewController ()
{
}

@end





@implementation RBPMiniGameSceneViewController

@dynamic view;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.backgroundColor = [UIColor lightGrayColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    [backButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
    [backButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10.0].active = YES;
    [backButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [backButton.heightAnchor constraintEqualToConstant:40].active = YES;
}

#pragma mark - RBPMiniGameSceneViewController

- (void)backButtonClicked:(UIButton *)button
{
    [self.delegate miniGameDidFinish:self];
}

#pragma mark - Internal

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




