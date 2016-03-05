//
//  RBPMiniGameSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController.h"

#import "RBPMiniGamePauseViewController.h"
#import "RBPMiniGameGameOverViewController.h"
#import "MZFormSheetPresentationViewController.h"

#import "RBPMiniGameScene.h"

#define PADDING 20.0





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
	
	
	UIButton *pauseButton = [[UIButton alloc] init];
	[pauseButton addTarget:self action:@selector(clickedPauseButton:) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
	pauseButton.backgroundColor = [UIColor lightGrayColor];
	[pauseButton setTitle:@"   Pause   " forState:UIControlStateNormal];
	[pauseButton sizeToFit];
	[self.view addSubview:pauseButton];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:PADDING]];
	
	
	self.progressView = [self progressViewInternal];
	[self.progressView setProgress:1.0 animated:NO];
	self.progressView.delegate = self;
	((RBPMiniGameScene *)self.view.scene).progressView = self.progressView;
	
	if (self.progressView) {
		
		[self.view addSubview:self.progressView];
		
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
															  attribute:NSLayoutAttributeLeft
															  relatedBy:NSLayoutRelationEqual
																 toItem:self.view
															  attribute:NSLayoutAttributeLeft
															 multiplier:1.0
															   constant:PADDING]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
															  attribute:NSLayoutAttributeTop
															  relatedBy:NSLayoutRelationEqual
																 toItem:self.view
															  attribute:NSLayoutAttributeTop
															 multiplier:1.0
															   constant:PADDING]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
															  attribute:NSLayoutAttributeWidth
															  relatedBy:NSLayoutRelationEqual
																 toItem:self.view
															  attribute:NSLayoutAttributeWidth
															 multiplier:0.25
															   constant:0.0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:pauseButton
															  attribute:NSLayoutAttributeHeight
															 multiplier:1.0
															   constant:0.0]];
		
	}
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	if (self.progressView) {
		[self.progressView setProgress:self.progressView.progress animated:NO];
	}
}

/**
 *  Override and return an instance of RBPProgressView
 *
 *  @return RBPProgressView
 */
- (RBPProgressView *)progressViewInternal
{
	return nil;
}

#pragma mark - RBPMiniGameSceneViewController

- (void)miniGameDidFinish
{
	RBPMiniGameGameOverViewController *viewController = [[RBPMiniGameGameOverViewController alloc] init];
	viewController.delegate = self;
	[self displayPauseViewController:viewController];
}

- (void)clickedPauseButton:(UIButton *)button
{
	RBPMiniGamePauseViewController *viewController = [[RBPMiniGamePauseViewController alloc] init];
	viewController.delegate = self;
	[self displayPauseViewController:viewController];
}

- (void)displayPauseViewController:(RBPMiniGamePauseViewController *)viewController
{
	self.view.scene.paused = YES;
	
	
	[self.progressView setProgress:self.progressView.progress animated:NO];
	
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc]
														initWithContentViewController:navigationController];
	
	
	CGSize contentViewSize = CGRectApplyAffineTransform(self.view.bounds, CGAffineTransformMakeScale(0.8, 0.7)).size;
	contentViewSize.height = MIN(contentViewSize.height, 350); // Clamp height for iPad
	formSheet.presentationController.contentViewSize = contentViewSize;
	// Center in view
	formSheet.presentationController.shouldCenterHorizontally = formSheet.presentationController.shouldCenterVertically = YES;
	formSheet.contentViewControllerTransitionStyle =  MZFormSheetPresentationTransitionStyleBounce;
	
	
	[self presentViewController:formSheet animated:YES completion:^{
	}];
}

#pragma mark - RBPMiniGamePauseViewControllerDelegate

- (void)pauseViewControllerDidSelectQuit
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
		[self.delegate miniGameDidFinish:self];
	}];
}

- (void)pauseViewControllerDidSelectResume
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
								  self.view.scene.paused = NO;
							  }];
}

- (void)pauseViewControllerDidSelectPlayAgain
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
								  [self.progressView setProgress:1.0 animated:NO];
								  [((RBPMiniGameScene *)self.view.scene) restart];
							  }];
}

#pragma mark - RBPProgressViewDelegate

- (void)progressDidReachZero:(RBPProgressView *)progressView
{
	if (!self.view.scene.isPaused) {
		[self miniGameDidFinish];
	}
}

@end




