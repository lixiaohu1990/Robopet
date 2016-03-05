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

@property (readwrite, nonatomic) CGFloat initialProgress;

@property (strong, nonatomic) UIView *progressFill;
@property (strong, nonatomic) NSLayoutConstraint *progressConstraint;

@end





@implementation RBPProgressView

- (id)initWithDefaultsKey:(NSString *)defaultsKey
{
	self = [self init];
	
	if (self) {
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:@{
																  @"wellnessLevel": @(1.0),
																  @"happinessLevel": @(1.0),
																  @"energyLevel": @(1.0),
																  }];
		
		self.defaultsKey = defaultsKey;
		self.initialProgress = self.progress;
		
	}
	
	return self;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		
		self.clipsToBounds = YES;
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = [UIColor whiteColor];
		
		self.progressFill = [[UIView alloc] init];
		self.progressFill.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.progressFill];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressFill
														 attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeTop
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressFill
														 attribute:NSLayoutAttributeLeft
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeLeft
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressFill
														 attribute:NSLayoutAttributeBottom
														 relatedBy:NSLayoutRelationEqual
															toItem:self
														 attribute:NSLayoutAttributeBottom
														multiplier:1.0
														  constant:0.0]];
		self.progressConstraint = [NSLayoutConstraint constraintWithItem:self.progressFill
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
	if (!animated) {
		
		[self.progressFill.layer removeAllAnimations];
		[self setProgress:progress animationDuration:0.0];
		
	} else {
		
		// default to 0.5 second animation time
		[self setProgress:progress animationDuration:0.5];
		
	}
}

- (void)setProgress:(CGFloat)progress animationDuration:(CGFloat)animationDuration
{
	NSAssert(self.defaultsKey && ![self.defaultsKey isEqualToString:@""], @"RBPProgressView dataKey cannot be nil");
	
	//clamp and save progress
	progress = MAX(0.0, MIN(1.0, progress));
	[[NSUserDefaults standardUserDefaults] setFloat:progress forKey:self.defaultsKey];
	
	[self layoutIfNeeded];
	
	[UIView animateWithDuration:animationDuration
						  delay:0.0
						options:(UIViewAnimationOptionAllowAnimatedContent |
								 UIViewAnimationOptionAllowUserInteraction |
								 UIViewAnimationOptionBeginFromCurrentState |
								 UIViewAnimationOptionCurveLinear)
					 animations:^{
						 
	
						 self.progressConstraint.constant = CGRectGetWidth(self.bounds) * progress;
						 [self layoutIfNeeded];
						 
					 }
					 completion:^(BOOL finished) {
						 
						 if (progress <= 0.0001) { // Close enough to 0
							 if (self.delegate && [self.delegate respondsToSelector:@selector(progressDidReachZero:)]) {
								 [self.delegate progressDidReachZero:self];
							 }
						 }
						 
					 }];
}

- (void)incrementProgress:(CGFloat)increment animated:(BOOL)animated
{
	[self setProgress:self.progress + increment animated:animated];
}

- (void)incrementProgress:(CGFloat)increment animationDuration:(CGFloat)animationDuration
{
	[self setProgress:self.progress + increment animationDuration:animationDuration];
}

#pragma mark - Static

+ (RBPProgressView *)wellnessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"wellnessLevel"];
	
	bar.progressFill.backgroundColor = [UIColor blueColor];
	
	return bar;
}

+ (RBPProgressView *)happinessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"happinessLevel"];
	
	bar.progressFill.backgroundColor = [UIColor purpleColor];
	
	return bar;
}

+ (RBPProgressView *)energyBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:@"energyLevel"];
	
	bar.progressFill.backgroundColor = [UIColor cyanColor];
	
	return bar;
}

#pragma mark - Internal

- (BOOL)isAnimating
{
	return (self.progressFill.layer.animationKeys && self.progressFill.layer.animationKeys.count > 0);
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




