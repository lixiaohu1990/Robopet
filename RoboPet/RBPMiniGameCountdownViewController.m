//
//  RBPMiniGameCountdownViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameCountdownViewController.h"





@interface RBPMiniGameCountdownViewController ()
{
}

@property (strong, nonatomic, readwrite) UILabel *label;

@end





@implementation RBPMiniGameCountdownViewController

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor blackColor];
	self.view.alpha = 0.8;
	
	
	self.label = [[UILabel alloc] init];
	self.label.numberOfLines = 2;
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	self.label.adjustsFontSizeToFitWidth = YES;
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.textColor = [UIColor whiteColor];
	[self.view addSubview:self.label];
	
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label
														  attribute:NSLayoutAttributeCenterY
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterY
														 multiplier:1.0
														   constant:0.0]];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	self.label.font = [UIFont systemFontOfSize:CGRectGetWidth(self.view.bounds) * 0.85]; // 85% because we will animate to 100%
}

#pragma mark - RBPMiniGameCountdownViewController

- (void)startCountdownWithSartTime:(NSInteger)startTime endTime:(NSInteger)endTime updateBlock:(void (^)(NSInteger currentTime))update
{
	if (update) {					// call update block
		update(startTime);
	}
	
	
	if (startTime < endTime) {		// timer is done
		self.label.text = nil;
		return;
	}
	
	
	// 1.0 seconds total
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 
						 self.label.transform = CGAffineTransformScale(self.label.transform, 1.15, 1.15);
						 self.text = [NSString stringWithFormat:@"%lu", (long)startTime];
						 
						 
					 }
					 completion:^(BOOL finished) {
						 
						 [UIView animateWithDuration:0.85
											   delay:0.0
											 options:UIViewAnimationOptionCurveEaseOut
										  animations:^{
											  
											  self.label.transform = CGAffineTransformIdentity;
											  
										  }
										  completion:^(BOOL finished) {
											  
											  [self startCountdownWithSartTime:startTime - 1 endTime:endTime updateBlock:update];
											  
										  }];
						 
					 }];
}

#pragma mark - Internal

- (void)setText:(NSString *)text
{
	_text = text;
	
	[UIView performWithoutAnimation:^{
		
		self.label.text = _text;
		
	}];
}

@end




