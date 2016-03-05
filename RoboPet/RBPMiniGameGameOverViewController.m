//
//  RBPMiniGameGameOverViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-02-29.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameGameOverViewController.h"

#define PADDING 20.0





@interface RBPMiniGameGameOverViewController ()
{
}

@end





@implementation RBPMiniGameGameOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Game Over";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Play Again"
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(onPlayAgain)];
	
}

- (void)onPlayAgain
{
	[self.delegate pauseViewControllerDidSelectPlayAgain];
}

@end




