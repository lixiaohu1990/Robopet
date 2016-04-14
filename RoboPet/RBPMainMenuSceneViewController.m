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

#import "RBPProgressView.h"

#define PADDING 20.0





@interface RBPMainMenuSceneViewController ()
{
}

@property (strong, nonatomic) IBOutlet UIView *wellnessBarContainer;
@property (strong, nonatomic) IBOutlet UIView *happinessBarContainer;
@property (strong, nonatomic) IBOutlet UIView *energyBarContainer;

@property (strong, nonatomic) RBPProgressView *wellnessBar;
@property (strong, nonatomic) RBPProgressView *happinessBar;
@property (strong, nonatomic) RBPProgressView *energyBar;

@end





@implementation RBPMainMenuSceneViewController

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupProgressBars];
}

- (void)setupProgressBars
{
    self.wellnessBarContainer.backgroundColor = [UIColor clearColor];
    self.happinessBarContainer.backgroundColor = [UIColor clearColor];
    self.energyBarContainer.backgroundColor = [UIColor clearColor];
    
	self.wellnessBar = [RBPProgressView wellnessBar];
	[self.wellnessBarContainer addSubview:self.wellnessBar];
	
	[self.wellnessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBarContainer
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:0.0]];
	[self.wellnessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBarContainer
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:0.0]];
	[self.wellnessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBarContainer
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:0.0]];
	[self.wellnessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.wellnessBar
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.wellnessBarContainer
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:0.0]];
	
	
	self.happinessBar = [RBPProgressView happinessBar];
	[self.happinessBarContainer addSubview:self.happinessBar];
	
    [self.happinessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.happinessBarContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.happinessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.happinessBarContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.happinessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.happinessBarContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.happinessBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.happinessBar
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.happinessBarContainer
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0]];
	
	
	self.energyBar = [RBPProgressView energyBar];
	[self.energyBarContainer addSubview:self.energyBar];
	
    [self.energyBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.energyBarContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.energyBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.energyBarContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.energyBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.energyBarContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0.0]];
    [self.energyBarContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.energyBar
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.energyBarContainer
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0]];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[self.wellnessBar setProgress:self.wellnessBar.progress animated:NO];
	[self.happinessBar setProgress:self.happinessBar.progress animated:NO];
	[self.energyBar setProgress:self.energyBar.progress animated:NO];
}

#pragma mark - RBPMainMenuSceneViewController

- (IBAction)miniGameButtonTapped:(UITapGestureRecognizer *)tap
{
    RBPMiniGameSceneViewController *miniGameViewController = nil;
    
    if (tap.view.tag == 0) {
        miniGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RBPMiniGameSceneViewController_Jump"];
    } else if (tap.view.tag == 1) {
        miniGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RBPMiniGameSceneViewController_Music"];
    } else if (tap.view.tag == 2) {
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
        formSheet.contentViewCornerRadius = 0.0;
        
        [self presentViewController:formSheet animated:YES completion:nil];
        
    }
}

#pragma mark - RBPMiniGameSceneViewControllerDelegate

- (void)miniGameDidFinish:(RBPMiniGameSceneViewController *)miniGameViewController
{
	[self.wellnessBar setProgress:self.wellnessBar.progress animated:NO];
	[self.happinessBar setProgress:self.happinessBar.progress animated:NO];
	[self.energyBar setProgress:self.energyBar.progress animated:NO];
	
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




