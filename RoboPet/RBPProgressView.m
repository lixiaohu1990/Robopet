//
//  RBPProgressView.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPProgressView.h"






@interface RBPProgressView()
{
}

@property (strong, nonatomic) NSLayoutConstraint *progressConstraint;

@end





@implementation RBPProgressView

- (id)initWithDefaultsKey:(NSString *)defaultsKey
{
	self = [self init];
	
	if (self) {
		
		self.defaultsKey = defaultsKey;
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:@{
																  @"wellnessLevel": @(1.0),
																  @"happinessLevel": @(1.0),
																  @"energyLevel": @(1.0),
																  }];
		
	}
	
	return self;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		
		self.clipsToBounds = YES;
		self.translatesAutoresizingMaskIntoConstraints = NO;
		
		UIView *progressFill = [[UIView alloc] init];
		progressFill.backgroundColor = [UIColor blackColor];
		progressFill.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:progressFill];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:progressFill
														 attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeTop
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:progressFill
														 attribute:NSLayoutAttributeLeft
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeLeft
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:progressFill
														 attribute:NSLayoutAttributeBottom
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeBottom
														multiplier:1.0
														  constant:0.0]];
		self.progressConstraint = [NSLayoutConstraint constraintWithItem:progressFill
															   attribute:NSLayoutAttributeRight
															   relatedBy:NSLayoutRelationEqual
																  toItem:self
															   attribute:NSLayoutAttributeLeft
															  multiplier:1.0
																constant:0.0];
		[self addConstraint:self.progressConstraint];
		
		
	}
	
	return self;
}

- (CGFloat)progress
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:self.defaultsKey];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
	NSAssert(self.defaultsKey && ![self.defaultsKey isEqualToString:@""], @"RBPProgressView dataKey cannot be nil");
	
	//clamp and save progress
	progress = MAX(0.0, MIN(1.0, progress));
	[[NSUserDefaults standardUserDefaults] setFloat:progress forKey:self.defaultsKey];
	
	[self.layer removeAllAnimations];
	
	if (!animated) {
		
		self.progressConstraint.constant = CGRectGetWidth(self.bounds) * progress;
		[self layoutIfNeeded];
		
	} else {
	
		[self layoutIfNeeded];
		
		[UIView animateWithDuration:0.6
							  delay:0.1
			 usingSpringWithDamping:0.6
			  initialSpringVelocity:0.4
							options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.progressConstraint.constant = CGRectGetWidth(self.bounds) * progress;
							 [self layoutIfNeeded];
						 } completion:^(BOOL finished) {
							 
						 }];
		
	}
}

- (void)incrementProgress:(CGFloat)increment animated:(BOOL)animated
{
	[self setProgress:self.progress + increment animated:animated];
}

+ (RBPProgressView *)wellnessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"wellnessLevel"];
	
	bar.backgroundColor = [UIColor blueColor];
	
	return bar;
}

+ (RBPProgressView *)happinessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"happinessLevel"];
	
	bar.backgroundColor = [UIColor purpleColor];
	
	return bar;
}

+ (RBPProgressView *)energyBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"energyLevel"];
	
	bar.backgroundColor = [UIColor cyanColor];
	
	return bar;
}

//TODO: REMOVE
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	CGFloat x = [[[touches allObjects] firstObject] locationInView:self].x;
	
	if (x < CGRectGetMidX(self.bounds))
		[self setProgress:self.progress - 0.1 animated:YES];
	else
		[self setProgress:self.progress + 0.1 animated:YES];
}

@end




