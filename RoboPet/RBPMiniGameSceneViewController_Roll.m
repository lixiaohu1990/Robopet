//
//  RBPMiniGameSceneViewController_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Roll.h"

#import "RBPMiniGameCountdownViewController.h"
#import "RBPMiniGameTutorialViewController.h"
#import "MZFormSheetPresentationViewController.h"

#import "RBPMiniGameScene_Roll.h"





@interface RBPMiniGameSceneViewController_Roll ()
{
}

@property (weak, nonatomic) RBPMiniGameScene_Roll *game;

@end





@implementation RBPMiniGameSceneViewController_Roll

@dynamic view;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (RBPProgressView *)progressViewInternal
{
	return [RBPProgressView energyBar];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Roll class];
}

- (NSString *)backgroundImageName
{
	return @"roll_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RBPMiniGameSceneViewController

- (void)miniGameWillStart
{
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
		[self performSelector:@selector(displayCountdownViewController:) withObject:viewController afterDelay:0.0];
	}];
}
	 
- (void)displayCountdownViewController:(RBPMiniGameCountdownViewController *)viewController
{
	// Main Thread
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		
		// Don't start countdown until Device is flat
		if (ABS(self.game.motion.accelerometerData.acceleration.x) > 0.2 || ABS(self.game.motion.accelerometerData.acceleration.y) > 0.2) {
			viewController.text = @"Hold Device Flat";
			[self performSelector:@selector(displayCountdownViewController:) withObject:viewController afterDelay:1.0];
			return;
		}
		
		[viewController startCountdownWithSartTime:3 endTime:1 updateBlock:^(NSInteger currentTime) {
			
			if (currentTime < 1) {
				[self dismissViewControllerAnimated:YES completion:^{
					[super miniGameWillStart];
				}];
			}
			
		}];
		
	});
	
}

- (void)miniGameWillResume
{
	[super miniGameWillResume];
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (NSArray<RBPMiniGameTutorialPage *> *)tutorialPages
{
	RBPMiniGameTutorialPage *pageOne = [[RBPMiniGameTutorialPage alloc] init];
	pageOne.textView.text = @"Tilt device to control Robot";
	
	RBPMiniGameTutorialPage *pageTwo = [[RBPMiniGameTutorialPage alloc] init];
	pageTwo.textView.text = @"Collect batteries to increase energy level";
	
	RBPMiniGameTutorialPage *pageThree = [[RBPMiniGameTutorialPage alloc] init];
	pageThree.textView.text = @"Avoid bumpers and walls";
	
	return @[pageOne, pageTwo, pageThree];
}

#pragma mark - Internal

- (RBPMiniGameScene_Roll *)game
{
	return (RBPMiniGameScene_Roll *)self.view.scene;
}

@end




