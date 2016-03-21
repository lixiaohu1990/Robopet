//
//  RBPMiniGameSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import AudioToolbox;

#import "RBPMiniGameSceneViewController.h"

#import "RBPMiniGamePauseViewController.h"
#import "RBPMiniGameGameOverViewController.h"
#import "MZFormSheetPresentationViewController.h"

#import "RBPMiniGameScene.h"

#define PADDING 20.0





@interface RBPMiniGameSceneViewController ()
{
}

@property (strong, nonatomic, readwrite) UILabel *scoreLabel;

@property (nonatomic, readwrite) SystemSoundID tickSound;

@end





@implementation RBPMiniGameSceneViewController

@dynamic view;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.scene.paused = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	[self setupScoreLabel];
	[self setupPauseButton];
	
	self.minigame.minigameDelegate = self;
	
	
	// Setup tick sound
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"minigame_countdown" withExtension:@"caf"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &_tickSound);
}

- (void)setupScoreLabel
{
	self.scoreLabel = [[UILabel alloc] init];
	self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addSubview:self.scoreLabel];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:PADDING]];
}

- (void)setupPauseButton
{
	UIButton *pauseButton = [[UIButton alloc] init];
	[pauseButton addTarget:self action:@selector(clickedPauseButton:) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
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
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	
	if ([RBPMiniGameTutorialViewController shouldShowTutorialForDelegate:self]) {
		RBPMiniGameTutorialViewController *viewController = [[RBPMiniGameTutorialViewController alloc] initWithDataSource:self];
		[self displayPopupViewController:viewController animated:YES completion:nil];
	} else {
		[self startMiniGame];
	}
	
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
	// If we havent started the mini game yet, go back to the main menu
	if (self.minigame.runningTime <= 0.0) {
		[self.delegate miniGameDidFinish:self];
	} else if (!self.presentedViewController) {
		[self displayPauseViewController:NO];
	}
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	// Fix bug with scenekit unpausing on app resume
	if (self.presentingViewController != nil) {
		self.view.scene.paused = YES;
	}
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - RBPMiniGameSceneViewController

- (void)startMiniGame
{
	self.minigame.minigameDelegate = self;
	
	RBPMiniGameCountdownViewController *viewController = [[RBPMiniGameCountdownViewController alloc] init];
	MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc]
														initWithContentViewController:viewController];
	
	
	CGSize contentViewSize = CGRectApplyAffineTransform(self.view.bounds, CGAffineTransformMakeScale(0.25, 0.0)).size;
	contentViewSize.height = contentViewSize.width; // Square
	formSheet.presentationController.contentViewSize = contentViewSize;
	// Center in view
	formSheet.presentationController.shouldCenterHorizontally = formSheet.presentationController.shouldCenterVertically = YES;
	formSheet.contentViewControllerTransitionStyle =  MZFormSheetPresentationTransitionStyleBounce;
	
	
	[self presentViewController:formSheet animated:NO completion:^{
		[self performSelector:@selector(startCountdownViewController:) withObject:viewController afterDelay:0.0];
	}];
}

- (void)startCountdownViewController:(RBPMiniGameCountdownViewController *)viewController
{
	// Main Thread
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		
		[viewController startCountdownWithSartTime:3
										   endTime:1
									   updateBlock:^(NSInteger currentTime) {
										   
										   if (currentTime < 1) {
											   [self dismissViewControllerAnimated:YES
																		completion:^{
																			[self countdownViewControllerDidDismiss:viewController];
																		}];
										   } else {
											   if ([RBPSoundManager soundEnabled]) {
												   AudioServicesPlaySystemSound(self.tickSound);
											   }
										   }
			
		}];
		
	});
	
}

- (void)countdownViewControllerDidDismiss:(RBPMiniGameCountdownViewController *)viewController
{
	self.view.scene.paused = NO;
}

- (void)resumeMiniGame
{
	self.view.scene.paused = NO;
}

- (void)clickedPauseButton:(UIButton *)button
{
	[self displayPauseViewController:YES];
}

- (void)displayPauseViewController:(BOOL)animated
{
	RBPMiniGamePauseViewController *viewController = [[RBPMiniGamePauseViewController alloc] init];
	[self displayPopupViewController:viewController animated:animated completion:nil];
}

- (void)displayPopupViewController:(RBPMiniGamePopupViewController *)viewController
						  animated:(BOOL)animated
						completion:(void (^)(void))completion
{
	self.view.scene.paused = YES;
	viewController.delegate = self;
	
	CGSize contentViewSize = CGRectApplyAffineTransform(self.view.bounds, CGAffineTransformMakeScale(0.8, 0.7)).size;
	//contentViewSize.height = MIN(contentViewSize.height, 350); // Clamp height for iPad
	viewController.preferredContentSize = contentViewSize;
	
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc]
														initWithContentViewController:navigationController];
	
	formSheet.presentationController.contentViewSize = viewController.preferredContentSize;
	// Center in view
	formSheet.presentationController.shouldCenterHorizontally = formSheet.presentationController.shouldCenterVertically = YES;
	formSheet.contentViewControllerTransitionStyle =  MZFormSheetPresentationTransitionStyleBounce;
	
	
	[self presentViewController:formSheet animated:animated completion:completion];
}

#pragma mark - RBPMiniGameSceneDelegate

- (void)onMiniGameScoreChange:(RBPMiniGameScene *)miniGame
{
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %0.1f", miniGame.score];
	[self.scoreLabel sizeToFit];
}

- (void)onMiniGameGameOver:(RBPMiniGameScene *)miniGame
{
	RBPMiniGameGameOverViewController *viewController = [[RBPMiniGameGameOverViewController alloc] initWithMiniGame:self.minigame];
	[self displayPopupViewController:viewController animated:YES completion:^{
		
		[viewController updateScoresAnimated:YES completion:^(BOOL finished) {
			if (finished){
				[viewController updateProgressViewAnimated:YES];
			}
		}];
		
	}];
}

#pragma mark - RBPMiniGamePopupViewControllerDelegate

- (void)popupViewController:(RBPMiniGamePopupViewController *)viewController didSelectOption:(NSString *)option
{
	[super dismissViewControllerAnimated:YES
							  completion:^{
								  
								  if ([viewController isKindOfClass:[RBPMiniGameTutorialViewController class]] &&
									  [option isEqualToString:@"Play"]) {
									  
									  [self startMiniGame];
									  
								  } else if ([viewController isKindOfClass:[RBPMiniGamePauseViewController class]] &&
											 [option isEqualToString:@"Resume"]) {
									  
									  [self resumeMiniGame];
									  
								  } else if ([viewController isKindOfClass:[RBPMiniGameGameOverViewController class]] &&
											 [option isEqualToString:@"Play Again"]) {
									  
									  
									  [self.minigame restart];
									  [self startMiniGame];
									  
								  } else if ([option isEqualToString:@"Quit"]) {
									  
									  [self.delegate miniGameDidFinish:self];
									  
								  } else {
									  
									  [self startMiniGame];
									  
								  }
								  
							  }];
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (UIScrollView *)tutorialScrollView;
{
	return nil;
}

#pragma mark - Internal

- (RBPMiniGameScene *)minigame
{
	return (RBPMiniGameScene *)self.view.scene;
}

@end




