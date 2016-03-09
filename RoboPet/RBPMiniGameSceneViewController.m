//
//  RBPMiniGameSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController.h"

#import "RBPMiniGamePopupViewController.h"
#import "RBPMiniGameTutorialViewController.h"
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
	
	self.view.scene.paused = YES;
	
	
	UIButton *pauseButton = [[UIButton alloc] init];
	[pauseButton addTarget:self action:@selector(clickedPauseButton:) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
	
	//pauseButton.backgroundColor = [UIColor lightGrayColor];
	//[pauseButton setTitle:@"   Pause   " forState:UIControlStateNormal];
	//[pauseButton sizeToFit];
	[pauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
	
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
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:pauseButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:pauseButton
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
	
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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Show tutorial view controller
	RBPMiniGameTutorialViewController *viewController = [[RBPMiniGameTutorialViewController alloc] initWithDataSource:self];
	[self displayPopupViewController:viewController animated:YES completion:nil];
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

- (void)miniGameWillStart
{
	self.view.scene.paused = NO;
}

- (void)miniGameWillResume
{
	self.view.scene.paused = NO;
}

- (void)miniGameDidFinish
{
	RBPMiniGameGameOverViewController *viewController = [[RBPMiniGameGameOverViewController alloc] init];
	[self displayPopupViewController:viewController animated:YES completion:nil];
}

- (void)clickedPauseButton:(UIButton *)button
{
	RBPMiniGamePauseViewController *viewController = [[RBPMiniGamePauseViewController alloc] init];
	[self displayPopupViewController:viewController animated:YES completion:nil];
}

- (void)displayPopupViewController:(RBPMiniGamePopupViewController *)viewController
						  animated:(BOOL)animated
						completion:(void (^)(void))completion
{
	self.view.scene.paused = YES;
	viewController.delegate = self;
	
	
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
	
	
	[self presentViewController:formSheet animated:animated completion:completion];
}

#pragma mark - RBPMiniGamePopupViewControllerDelegate

- (void)popupViewController:(RBPMiniGamePopupViewController *)viewController didSelectOption:(NSString *)option
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
								  
								  if ([viewController isKindOfClass:[RBPMiniGameTutorialViewController class]] &&
									  [option isEqualToString:@"Play"]) {
									  
									  [self miniGameWillStart];
									  
								  } else if ([viewController isKindOfClass:[RBPMiniGamePauseViewController class]] &&
											 [option isEqualToString:@"Resume"]) {
									  
									  [self miniGameWillResume];
									  
								  } else if ([viewController isKindOfClass:[RBPMiniGameGameOverViewController class]] &&
											 [option isEqualToString:@"Play Again"]) {
									  
									  [self.progressView setProgress:1.0 animated:NO];
									  [((RBPMiniGameScene *)self.view.scene) restart];
									  [self miniGameWillStart];
									  
								  } else if ([option isEqualToString:@"Quit"]) {
									  
									  [self.delegate miniGameDidFinish:self];
									  
								  }
								  
							  }];
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (NSArray<RBPMiniGameTutorialPage *> *)tutorialPages
{
	// Override me
	return @[];
}

#pragma mark - RBPProgressViewDelegate

- (void)progressDidReachZero:(RBPProgressView *)progressView
{
	if (!self.view.scene.isPaused) {
		[self miniGameDidFinish];
	}
}

@end




