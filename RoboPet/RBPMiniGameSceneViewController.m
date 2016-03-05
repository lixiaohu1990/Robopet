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

- (void)clickedPauseButton:(UIButton *)button
{
	self.view.scene.paused = YES;
	
	RBPMiniGameGameOverViewController *pauseViewController = [[RBPMiniGameGameOverViewController alloc] init];
	pauseViewController.delegate = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pauseViewController];
	MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc]
														initWithContentViewController:navigationController];
	CGSize contentViewSize = CGRectApplyAffineTransform(self.view.bounds, CGAffineTransformMakeScale(0.8, 0.7)).size;
	contentViewSize.height = MIN(contentViewSize.height, 350);
	formSheet.presentationController.contentViewSize = contentViewSize;
	
	formSheet.presentationController.shouldCenterHorizontally = formSheet.presentationController.shouldCenterVertically = YES;
	formSheet.presentationController.shouldUseMotionEffect = YES;
	
	[self presentViewController:formSheet animated:YES completion:nil];
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
								  self.view.scene.paused = YES;
							  }];
}

- (void)pauseViewControllerDidSelectPlayAgain
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
								  [((RBPMiniGameScene *)self.view.scene) restart];
							  }];
}

@end




