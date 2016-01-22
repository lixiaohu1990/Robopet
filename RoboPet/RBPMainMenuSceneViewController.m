//
//  RBPMainMenuSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMainMenuSceneViewController.h"

#import "RBPMainMenuScene.h"
//#import "RBPMiniGameSceneViewController_Jump.h"
//#import "RBPMiniGameSceneViewController_Music.h"
#import "RBPMiniGameSceneViewController_Roll.h"





@interface RBPMainMenuSceneViewController ()
{
}

@end





@implementation RBPMainMenuSceneViewController

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Temp
    UIButton *jumpButton = [[UIButton alloc] init];
    [jumpButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    jumpButton.translatesAutoresizingMaskIntoConstraints = NO;
    jumpButton.backgroundColor = [UIColor lightGrayColor];
    [jumpButton setTitle:@"Jump" forState:UIControlStateNormal];
    [self.view addSubview:jumpButton];
    
    [jumpButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-150.0].active = YES;
    [jumpButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:0.0].active = YES;
    [jumpButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [jumpButton.heightAnchor constraintEqualToConstant:100].active = YES;
    
    
    UIButton *musicButton = [[UIButton alloc] init];
    [musicButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    musicButton.translatesAutoresizingMaskIntoConstraints = NO;
    musicButton.backgroundColor = [UIColor lightGrayColor];
    [musicButton setTitle:@"Music" forState:UIControlStateNormal];
    [self.view addSubview:musicButton];
    
    [musicButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0.0].active = YES;
    [musicButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:0.0].active = YES;
    [musicButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [musicButton.heightAnchor constraintEqualToConstant:100].active = YES;
    
    
    UIButton *rollButton = [[UIButton alloc] init];
    [rollButton addTarget:self action:@selector(clickedLoadMiniGameButton:) forControlEvents:UIControlEventTouchUpInside];
    rollButton.translatesAutoresizingMaskIntoConstraints = NO;
    rollButton.backgroundColor = [UIColor lightGrayColor];
    [rollButton setTitle:@"Roll" forState:UIControlStateNormal];
    [self.view addSubview:rollButton];
    
    [rollButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:150.0].active = YES;
    [rollButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:0.0].active = YES;
    [rollButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [rollButton.heightAnchor constraintEqualToConstant:100].active = YES;
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
        [self showViewController:miniGameViewController sender:self];
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

#pragma mark - Internal

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




