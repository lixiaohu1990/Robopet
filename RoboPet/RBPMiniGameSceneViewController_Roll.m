//
//  RBPMiniGameSceneViewController_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Roll.h"

#import "RBPMiniGameScene_Roll.h"





@interface RBPMiniGameSceneViewController_Roll ()
{
}

@property (weak, nonatomic) RBPMiniGameScene_Roll *minigame;

@end





@implementation RBPMiniGameSceneViewController_Roll

@dynamic view;
@dynamic minigame;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)startCountdownViewController:(RBPMiniGameCountdownViewController *)viewController
{
	// Don't start countdown until Device is flat
	if (ABS(self.minigame.motion.accelerometerData.acceleration.x) > 0.2 ||
		ABS(self.minigame.motion.accelerometerData.acceleration.y) > 0.2) {
		
		viewController.text = @"Rotate Device\nHorizontally";
		[self performSelector:@selector(startCountdownViewController:) withObject:viewController afterDelay:1.0];
		
	} else {
		
		[super startCountdownViewController:viewController];
		
	}
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

- (RBPMiniGameScene_Roll *)minigame
{
	return (RBPMiniGameScene_Roll *)self.view.scene;
}

@end




