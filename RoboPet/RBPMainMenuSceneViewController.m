//
//  RBPMainMenuSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMainMenuSceneViewController.h"

#import "RBPMainMenuScene.h"
#import "RBPMiniGameSceneViewController.h"
#import "MZFormSheetPresentationViewController.h"





@interface RBPMainMenuSceneViewController ()
{
}

@end





@implementation RBPMainMenuSceneViewController

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Temporary buttons
    UIButton *jumpButton = [[UIButton alloc] init];
    [jumpButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    jumpButton.translatesAutoresizingMaskIntoConstraints = NO;
    jumpButton.backgroundColor = [UIColor lightGrayColor];
    [jumpButton setTitle:@"Jump" forState:UIControlStateNormal];
    [self.view addSubview:jumpButton];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:jumpButton
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:-150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:jumpButton
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:jumpButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:jumpButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	
	
    
    UIButton *musicButton = [[UIButton alloc] init];
    [musicButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    musicButton.translatesAutoresizingMaskIntoConstraints = NO;
    musicButton.backgroundColor = [UIColor lightGrayColor];
    [musicButton setTitle:@"Music" forState:UIControlStateNormal];
    [self.view addSubview:musicButton];
    
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:musicButton
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:musicButton
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:musicButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:musicButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	
	
	
    UIButton *rollButton = [[UIButton alloc] init];
    [rollButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    rollButton.translatesAutoresizingMaskIntoConstraints = NO;
    rollButton.backgroundColor = [UIColor lightGrayColor];
    [rollButton setTitle:@"Roll" forState:UIControlStateNormal];
    [self.view addSubview:rollButton];
    
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:rollButton
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:rollButton
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:rollButton
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:rollButton
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:100.0]];
}

#pragma mark - RBPMainMenuSceneViewController

- (void)clickedLoadMiniGameButton:(UIButton *)button
{
	NSString *buttonTitle = [button titleForState:UIControlStateNormal];
    RBPMiniGameSceneViewController *miniGameViewController = nil;
    
    if ([buttonTitle isEqualToString:@"Jump"]) {
        miniGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RBPMiniGameSceneViewController_Jump"];
    } else if ([buttonTitle isEqualToString:@"Music"]) {
        miniGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RBPMiniGameSceneViewController_Music"];
    } else if ([buttonTitle isEqualToString:@"Roll"]) {
        miniGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RBPMiniGameSceneViewController_Roll"];
    }
    
    if (miniGameViewController) {
		
		miniGameViewController.delegate = self;
		
		MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc]
															initWithContentViewController:miniGameViewController];
		
		// Full Screen and Centred
		formSheet.presentationController.contentViewSize = self.view.bounds.size;
		formSheet.presentationController.shouldCenterHorizontally = formSheet.presentationController.shouldCenterVertically = YES;
		formSheet.contentViewControllerTransitionStyle =  MZFormSheetPresentationTransitionStyleDropDown;
		
		[self presentViewController:formSheet animated:YES completion:nil];
		
    }
}

#pragma mark - RBPMiniGameSceneViewControllerDelegate

- (void)miniGameDidFinish:(RBPMiniGameSceneViewController *)miniGameViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMainMenuScene class];
}

- (NSString *)backgroundImageName
{
	return @"mainmenu_background";
}

#pragma mark - Internal

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




