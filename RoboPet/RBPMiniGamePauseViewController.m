//
//  RBPMiniGamePauseViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGamePauseViewController.h"

#import "RBPSoundManager.h"
#import "RBPProgressView.h"





@interface RBPMiniGamePauseViewController ()
{
}

@end





@implementation RBPMiniGamePauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Paused";
	self.navigationItem.rightBarButtonItem.title = @"Resume";
	
	
	self.soundButton = [[UIButton alloc] init];
	[self.soundButton addTarget:self action:@selector(clickedSoundButton:) forControlEvents:UIControlEventTouchUpInside];
	self.soundButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self updateSoundButton:self.soundButton];
	[self.view addSubview:self.soundButton];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.soundButton
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.soundButton
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.soundButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.soundButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.soundButton
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
	
	self.wellnessBar = [RBPProgressView wellnessBar];
	[self.view addSubview:self.wellnessBar];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:CGRectGetMaxY(self.navigationController.navigationBar.bounds) + PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeWidth
														 multiplier:0.5
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.soundButton
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
	
	self.happinessBar = [RBPProgressView happinessBar];
	[self.view addSubview:self.happinessBar];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:CGRectGetMaxY(self.navigationController.navigationBar.bounds) / 2.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeWidth
														 multiplier:0.5
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.soundButton
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
	
	self.energyBar = [RBPProgressView energyBar];
	[self.view addSubview:self.energyBar];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeWidth
														 multiplier:0.5
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.soundButton
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
}

- (void)clickedSoundButton:(UIButton *)button
{
	// Toggle state
	[RBPSoundManager setSoundEnabled:![RBPSoundManager soundEnabled]];
	
	[self updateSoundButton:button];
}

- (void)updateSoundButton:(UIButton *)button
{
	//[button setTitle:[RBPSoundManager soundEnabled] ? @"Mute" : @"UnMute" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:[RBPSoundManager soundEnabled] ? @"sound_on_button" : @"sound_off_button"] forState:UIControlStateNormal];
	//[button sizeToFit];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[self.wellnessBar setProgress:self.wellnessBar.progress animated:YES];
	[self.happinessBar setProgress:self.happinessBar.progress animated:YES];
	[self.energyBar setProgress:self.energyBar.progress animated:YES];
}

@end




