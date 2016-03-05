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

#define PADDING 20.0





@interface RBPMiniGamePauseViewController ()
{
}

@property (strong, nonatomic) RBPProgressView *wellnessBar;
@property (strong, nonatomic) RBPProgressView *happinessBar;
@property (strong, nonatomic) RBPProgressView *energyBar;

@end





@implementation RBPMiniGamePauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	self.view = [[UIView alloc] init];
	self.view.alpha = 0.8;
	self.view.backgroundColor = [UIColor blackColor];
	
	self.navigationItem.title = @"Paused";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Quit"
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(onQuit)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Resume"
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(onResume)];
	
	
	UIButton *soundButton = [[UIButton alloc] init];
	[soundButton addTarget:self action:@selector(clickedSoundButton:) forControlEvents:UIControlEventTouchUpInside];
	soundButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self updateSoundButton:soundButton];
	[self.view addSubview:soundButton];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:soundButton
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:soundButton
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:-PADDING]];
	
	
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
															 toItem:soundButton
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
															 toItem:soundButton
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
															 toItem:soundButton
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
	[button setTitle:[RBPSoundManager soundEnabled] ? @"Mute" : @"UnMute" forState:UIControlStateNormal];
	[button sizeToFit];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[self.wellnessBar setProgress:self.wellnessBar.progress animated:YES];
	[self.happinessBar setProgress:self.happinessBar.progress animated:YES];
	[self.energyBar setProgress:self.energyBar.progress animated:YES];
}

- (void)onQuit
{
	[self.delegate pauseViewControllerDidSelectQuit];
}

- (void)onResume
{
	[self.delegate pauseViewControllerDidSelectResume];
}

@end




