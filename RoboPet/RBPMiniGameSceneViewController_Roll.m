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
		
		[viewController startCountdownWithSartTime:3 endTime:1 updateBlock:^(NSInteger currentTime) {
			
			if (currentTime < 1) {
				[self dismissViewControllerAnimated:YES completion:^{
					[super miniGameWillStart];
				}];
			}
			
		}];
	}];
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

@end




