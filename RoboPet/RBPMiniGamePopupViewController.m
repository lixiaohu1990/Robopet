//
//  RBPMiniGamePopupViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGamePopupViewController.h"





@interface RBPMiniGamePopupViewController ()
{	
}

@end





@implementation RBPMiniGamePopupViewController

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view = [[UIView alloc] init];
	self.view.alpha = 0.8;
	
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Quit"
																			 style:UIBarButtonItemStylePlain
																			target:self
																			action:@selector(clickedBarButton:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Play"
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(clickedBarButton:)];
	
	
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transition_screen"]];
	backgroundView.contentMode = UIViewContentModeScaleToFill;
	backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:backgroundView];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:CGRectGetMaxY(self.navigationController.navigationBar.bounds)]];
}

- (void)clickedBarButton:(UIBarButtonItem *)barButtonItem
{
	if (self.delegate) {
		[self.delegate popupViewController:self didSelectOption:barButtonItem.title];
	}
}

@end




