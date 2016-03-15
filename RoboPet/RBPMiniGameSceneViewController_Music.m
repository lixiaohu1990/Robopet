//
//  RBPMiniGameSceneViewController_Music.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Music.h"

#import "RBPMiniGameScene_Music.h"

#import "RBPMiniGameTutorialViewController.h"

#import "RBPMiniGameCountdownViewController.h"
#import "MZFormSheetPresentationViewController.h"





@interface RBPMiniGameSceneViewController_Music ()
{
}

@end





@implementation RBPMiniGameSceneViewController_Music

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (RBPProgressView *)progressViewInternal
{
	return [RBPProgressView happinessBar];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Music class];
}

- (NSString *)backgroundImageName
{
	return @"music_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (NSArray<RBPMiniGameTutorialPage *> *)tutorialPages
{
	RBPMiniGameTutorialPage *pageOne = [[RBPMiniGameTutorialPage alloc] init];
	pageOne.textView.text = @"Tutorial Page 1";
	
	RBPMiniGameTutorialPage *pageTwo = [[RBPMiniGameTutorialPage alloc] init];
	pageTwo.textView.text = @"Tutorial Page 2";
	
	RBPMiniGameTutorialPage *pageThree = [[RBPMiniGameTutorialPage alloc] init];
	pageThree.textView.text = @"Tutorial Page 3";
	
	return @[pageOne, pageTwo, pageThree];
}




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

@end




