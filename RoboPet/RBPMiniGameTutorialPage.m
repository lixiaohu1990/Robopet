//
//  RBPMiniGameTutorialPage.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-09.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameTutorialPage.h"





@implementation RBPMiniGameTutorialPage

- (id)init
{
	self = [super init];
	
	if (self) {
		
		// Setup PageControl
		self.textView = [[UITextView alloc] init];
		self.textView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.textView];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
															  attribute:NSLayoutAttributeWidth
															  relatedBy:NSLayoutRelationEqual
																 toItem:self
															  attribute:NSLayoutAttributeWidth
															 multiplier:0.5
															   constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:self
															  attribute:NSLayoutAttributeHeight
															 multiplier:0.5
															   constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
															  attribute:NSLayoutAttributeCenterX
															  relatedBy:NSLayoutRelationEqual
																 toItem:self
															  attribute:NSLayoutAttributeCenterX
															 multiplier:1.0
															   constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
															  attribute:NSLayoutAttributeCenterY
															  relatedBy:NSLayoutRelationEqual
																 toItem:self
															  attribute:NSLayoutAttributeCenterY
															 multiplier:1.0
															   constant:0.0]];
		
	}
	
	return self;
}

@end




