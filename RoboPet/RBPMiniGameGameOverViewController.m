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

@property (strong, nonatomic) UILabel *labelOne;
@property (strong, nonatomic) UILabel *labelTwo;

@property (strong, nonatomic) NSString *labelOneText;
@property (strong, nonatomic) NSString *labelTwoText;

@end





@implementation RBPMiniGameGameOverViewController

#pragma mark - Init

- (id)initWithMiniGame:(RBPMiniGameScene *)miniGame
{
	self = [super init];
	
	if (self) {
		
		NSAssert(miniGame, @"");
		self.miniGame = miniGame;
		
		// cache these before they get overwritten
		if (self.miniGame.score >= self.miniGame.highScore && self.miniGame.score > 0) { // New high score
			self.labelOneText = [NSString stringWithFormat:@"%@", @"New HighScore!"];
			self.labelTwoText = [NSString stringWithFormat:@"%lu", (long)self.miniGame.score];
		} else {
			self.labelOneText = [NSString stringWithFormat:@"%-20s%lu", "Score:", (long)self.miniGame.score];
			self.labelTwoText = [NSString stringWithFormat:@"%-15s%lu", "HighScore:", (long)self.miniGame.highScore];
		}
		
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Game Over";
	self.navigationItem.rightBarButtonItem.title = @"Play Again";
	
	
	self.labelOne = [[UILabel alloc] init];
	self.labelTwo = [[UILabel alloc] init];
	
	self.labelOne.translatesAutoresizingMaskIntoConstraints = self.labelTwo.translatesAutoresizingMaskIntoConstraints = NO;
	self.labelOne.adjustsFontSizeToFitWidth = self.labelTwo.adjustsFontSizeToFitWidth = YES;
	self.labelOne.textAlignment = self.labelTwo.textAlignment = NSTextAlignmentLeft;
	self.labelOne.backgroundColor = self.labelTwo.backgroundColor = [UIColor clearColor];

	[self.view addSubview:self.labelOne];
	[self.view addSubview:self.labelTwo];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelOne
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBar
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelOne
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelOne
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBar
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelOne
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBar
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTwo
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.happinessBar
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTwo
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:-PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTwo
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.happinessBar
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTwo
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.happinessBar
														  attribute:NSLayoutAttributeHeight
														 multiplier:1.0
														   constant:0.0]];
}

#pragma mark - RBPMiniGameGameOverViewController

- (void)updateScoresAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
	//self.textview.alpha = 0.0;
	
	CGFloat delay = (animated ? RBPPROGRESSVIEW_ANIMATION_TIME : 0.0);
	CGFloat duration = delay;
	
	// x second delay so the main progress bars have finished animating
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
				   dispatch_get_main_queue(), ^{
					   
					   [UIView transitionWithView:self.labelOne
										 duration:duration
										  options:UIViewAnimationOptionTransitionFlipFromRight
									   animations:^{
										   
										   [self setText:self.labelOneText onLabel:self.labelOne];
										   
									   }
									   completion:^(BOOL finished) {
										   
										   [UIView transitionWithView:self.labelTwo
															 duration:duration
															  options:UIViewAnimationOptionTransitionFlipFromRight
														   animations:^{
															   
															   [self setText:self.labelTwoText onLabel:self.labelTwo];
															   
														   }
														   completion:completion];
										   
									   }];
					   
				   });
}

- (void)updateProgressViewAnimated:(BOOL)animated
{
	// 100 score will be a full bar
	CGFloat progressGained = self.miniGame.score / 100.0;
	
	if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Jump class]]) {
		[self.wellnessBar incrementProgress:progressGained animated:animated];
	} else if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Music class]]) {
		[self.happinessBar incrementProgress:progressGained animated:animated];
	} else if ([self.miniGame isKindOfClass:[RBPMiniGameScene_Roll class]]) {
		[self.energyBar incrementProgress:progressGained animated:animated];
	}
}

#pragma mark - Internal

/**
 *  Helper method to auto update the attributed text
 *
 *  @param text
 *  @param label
 */
- (void)setText:(NSString *)text onLabel:(UILabel *)label
{
	label.attributedText = [[NSMutableAttributedString alloc] initWithString:text
																  attributes:@{
																			   NSFontAttributeName : [UIFont boldSystemFontOfSize:21],
																			   NSStrokeColorAttributeName : [UIColor blackColor],
																			   NSForegroundColorAttributeName : [UIColor whiteColor],
																			   NSStrokeWidthAttributeName : @(-3.0)
																			   }];
}

@end




