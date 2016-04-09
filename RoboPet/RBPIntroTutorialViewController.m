//
//  RBPIntroTutorialViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-04-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPIntroTutorialViewController.h"


#define HAS_SHOWN_INTRO_SLIDESHOW_DEFAULTS_KEY @"RBPHasShownIntroSlideshowDefaultsKey"

#define STAGE_1_DETAIL_MESSAGE @"HI! I'M COMPUBOT\nI'M YOUR NEW ROBOT PET"
#define STAGE_2_DETAIL_MESSAGE @"PLAY MINI-GAMES\nTO KEEP ME ENERGIZED,\nHAPPY AND VIRUS FREE"
#define STAGE_3_DETAIL_MESSAGE @"PLEASE TAKE GOOD\nCARE OF ME!"

#ifdef DEBUG

	#define STAGE_1_ANIMATION_DELAY 1.0
	#define STAGE_1_ANIMATION_DURATION 1.0

	#define STAGE_2_ANIMATION_DELAY 1.0
	#define STAGE_2_ANIMATION_DURATION 1.0

	#define STAGE_3_ANIMATION_DELAY 1.0

#else

	#define STAGE_1_ANIMATION_DELAY 4.0
	#define STAGE_1_ANIMATION_DURATION 1.5

	#define STAGE_2_ANIMATION_DELAY 4.0
	#define STAGE_2_ANIMATION_DURATION 1.5

	#define STAGE_3_ANIMATION_DELAY 4.0

#endif







@interface RBPIntroTutorialViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelBottom;

@property (strong, nonatomic) IBOutlet UIImageView *robot;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *robotCenterXConstraint;
@property (strong, nonatomic) IBOutlet UIView *minigamePane;

@end





@implementation RBPIntroTutorialViewController

#pragma makr - Init

- (void)viewDidLoad
{
	[super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.minigamePane.layer.cornerRadius = 10;
	self.minigamePane.clipsToBounds = YES;
	
	self.labelDetail.alpha = 0.0;
	self.labelBottom.alpha = 0.0;
	self.minigamePane.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
#ifdef DEBUG
	
	[self startAnimation];
	
#else
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:HAS_SHOWN_INTRO_SLIDESHOW_DEFAULTS_KEY]) {
		
		[self pushMainMenu];
		
	} else {
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_SHOWN_INTRO_SLIDESHOW_DEFAULTS_KEY];
		[self startAnimation];
		
	}
	
#endif
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	for (UIView *subview in self.view.subviews) {
		[subview.layer removeAllAnimations];
		[subview removeFromSuperview];
	}
	[self.view.layer removeAllAnimations];
	
	self.labelDetail = nil;
	self.labelBottom = nil;
	self.robot = nil;
	self.minigamePane = nil;
}

#pragma mark - RBPIntroTutorialViewController

- (void)pushMainMenu
{
	if (!self.presentedViewController) {
		[self performSegueWithIdentifier:@"RBPMainMenuSceneViewController" sender:nil];
	}
}

- (void)startAnimation
{
	[self.view layoutIfNeeded];
	
	[self setText:STAGE_1_DETAIL_MESSAGE onLabel:self.labelDetail];
	[self setText:self.labelBottom.text onLabel:self.labelBottom];
	
	[UIView animateWithDuration:0.25
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
						 self.labelDetail.alpha = 1.0;
						 self.labelBottom.alpha = 1.0;
								
					 } completion:^(BOOL finished) {
						 
						 // Stage 1
						 [UIView animateWithDuration:STAGE_1_ANIMATION_DURATION
											   delay:STAGE_1_ANIMATION_DELAY
											 options:UIViewAnimationOptionCurveEaseInOut
										  animations:^{
											  
											  // move to left 15% of screen
											  self.robotCenterXConstraint.constant = CGRectGetWidth(self.view.bounds) * -0.30;
											  self.minigamePane.alpha = 1.0;
											  [self.view layoutIfNeeded];
											  
										  } completion:^(BOOL finished) {
											  
											  if (finished) {
												  
												  [self setText:STAGE_2_DETAIL_MESSAGE onLabel:self.labelDetail];
												  self.robot.image = [UIImage imageNamed:@"robot_front_2"];
												  
												  // Stage 1
												  [UIView animateWithDuration:STAGE_2_ANIMATION_DURATION
																		delay:STAGE_2_ANIMATION_DELAY
																	  options:UIViewAnimationOptionCurveEaseInOut
																   animations:^{
																	   
																	   self.robotCenterXConstraint.constant = 0.0;
																	   self.minigamePane.alpha = 0.0;
																	   [self.view layoutIfNeeded];
																	   
																   } completion:^(BOOL finished) {
																	   
																	   if (finished) {
																		   
																		   [self setText:STAGE_3_DETAIL_MESSAGE onLabel:self.labelDetail];
																		   self.robot.image = [UIImage imageNamed:@"robot_front_3"];
																		   [self performSelector:@selector(pushMainMenu) withObject:nil afterDelay:STAGE_3_ANIMATION_DELAY];
																		   
																	   }
																	   
																   }];
												  
											  }
											  
										  }];
						 
					 }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	// Cancel our perform selector after delay to show main menu
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushMainMenu) object:nil];
	[self pushMainMenu];
}

/**
 *  Helper method to auto update the attributed text
 *
 *  @param text
 *  @param label
 */
- (void)setText:(NSString *)text onLabel:(UILabel *)label
{
	label.attributedText = [[NSAttributedString alloc] initWithString:text
														   attributes:@{
																		NSFontAttributeName : [UIFont boldSystemFontOfSize:label.font.pointSize],
																		NSStrokeColorAttributeName : [UIColor blackColor],
																		NSForegroundColorAttributeName : [UIColor whiteColor],
																		NSStrokeWidthAttributeName : @(-3.0)
																		}];
}

@end




