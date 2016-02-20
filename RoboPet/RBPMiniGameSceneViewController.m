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
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backButton
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:10.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backButton
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:10.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:40.0]];
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




