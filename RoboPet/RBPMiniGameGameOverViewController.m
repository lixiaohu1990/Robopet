//
//  RBPMiniGameGameOverViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameGameOverViewController.h"

#import "RBPMiniGameScene.h"
#import "RBPMiniGameScene_Jump.h"
#import "RBPMiniGameScene_Music.h"
#import "RBPMiniGameScene_Roll.h"

#import "RBPProgressView.h"





@interface RBPMiniGameGameOverViewController ()
{
}

@property (weak, nonatomic) RBPMiniGameScene *miniGame;

@property (strong, nonatomic) NSString *gameOverMessage;

@property (strong, nonatomic) UITextView *textview;

@end





@implementation RBPMiniGameGameOverViewController

#pragma mark - Init

- (id)initWithMiniGame:(RBPMiniGameScene *)miniGame
{
	self = [super init];
	
	if (self) {
		NSAssert(miniGame, @"");
		
		self.miniGame = miniGame;
		
		self.gameOverMessage = self.miniGame.gameOverMessage;
		
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Game Over";
	self.navigationItem.rightBarButtonItem.title = @"Play Again";
	
	self.textview = [[UITextView alloc] init];
	self.textview.translatesAutoresizingMaskIntoConstraints = NO;
	self.textview.userInteractionEnabled = NO;
	self.textview.font = [UIFont systemFontOfSize:16];
	self.textview.textColor = [UIColor whiteColor];
	self.textview.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:self.textview];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textview
																		   attribute:NSLayoutAttributeLeft
																		   relatedBy:NSLayoutRelationEqual
																			  toItem:self.wellnessBar
																		   attribute:NSLayoutAttributeRight
																		  multiplier:1.0
																			constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textview
																		   attribute:NSLayoutAttributeRight
																		   relatedBy:NSLayoutRelationEqual
																			  toItem:self.soundButton
																		   attribute:NSLayoutAttributeRight
																		  multiplier:1.0
																			constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textview
																		   attribute:NSLayoutAttributeTop
																		   relatedBy:NSLayoutRelationEqual
																			  toItem:self.wellnessBar
																		   attribute:NSLayoutAttributeTop
																		  multiplier:1.0
																			constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textview
																		   attribute:NSLayoutAttributeBottom
																		   relatedBy:NSLayoutRelationEqual
																			  toItem:self.soundButton
																		   attribute:NSLayoutAttributeTop
																		  multiplier:1.0
																			constant:-PADDING]];
}

#pragma mark - RBPMiniGameGameOverViewController

- (void)updateScoresAnimated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion
{
	//self.textview.alpha = 0.0;
	
	CGFloat delay = (animated ? RBPPROGRESSVIEW_ANIMATION_TIME : 0.0);
	CGFloat duration = delay;
	
	// x second delay so the main progress bars have finished animating
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
				   dispatch_get_main_queue(), ^{
					   
					   [UIView transitionWithView:self.textview
										 duration:duration
										  options:UIViewAnimationOptionTransitionFlipFromTop
									   animations:^{
										   self.textview.text = self.gameOverMessage;
									   }
									   completion:completion];
					   
				   });
}

- (void)updateProgressViewAnimated:(BOOL)animated
{
	// 100 score will be a full bar
	CGFloat progressGained = self.miniGame.score / 100.0;
	
	CGFloat delay = (animated ? RBPPROGRESSVIEW_ANIMATION_TIME : 0.0);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
				   dispatch_get_main_queue(), ^{
					   
					   if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Jump class]]) {
						   [self.wellnessBar incrementProgress:progressGained animated:animated];
					   } else if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Music class]]) {
						   [self.happinessBar incrementProgress:progressGained animated:animated];
					   } else if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Roll class]]) {
						   [self.energyBar incrementProgress:progressGained animated:animated];
					   }
					   
				   });
}

@end




