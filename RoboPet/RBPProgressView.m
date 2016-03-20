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

@property (strong, nonatomic) UIImageView *progressBackground;
@property (strong, nonatomic) UIImageView *progressFill;
@property (strong, nonatomic) NSLayoutConstraint *progressFillConstraint;

@end





@implementation RBPProgressView

#pragma mark - Init

- (id)initWithDefaultsKey:(NSString *)defaultsKey
{
	self = [self init];
	
	if (self) {
	
		[[NSUserDefaults standardUserDefaults] registerDefaults:@{
																  WELLNESS_DEFAULTS_KEY: @(1.0),
																  HAPPINESS_DEFAULTS_KEY: @(1.0),
																  ENERGY_DEFAULTS_KEY: @(1.0),
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
		self.backgroundColor = [UIColor clearColor];
		self.layer.borderWidth = 3;
		
		
		
		UIImage *progressFillImage = [UIImage imageNamed:@"progressbar_fill"];
		
		self.progressFill = [[UIImageView alloc] initWithImage:progressFillImage];
		self.progressFill.contentMode = UIViewContentModeScaleToFill;
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
		self.progressFillConstraint = [NSLayoutConstraint constraintWithItem:self.progressFill
															   attribute:NSLayoutAttributeRight
															   relatedBy:NSLayoutRelationEqual
																  toItem:self
															   attribute:NSLayoutAttributeLeft
															  multiplier:1.0
																constant:0.0];
		[self addConstraint:self.progressFillConstraint];
		
		
		self.progressBackground = [[UIImageView alloc] initWithImage:progressFillImage];
		self.progressBackground.contentMode = UIViewContentModeScaleToFill;
		self.progressBackground.translatesAutoresizingMaskIntoConstraints = NO;
		[self.progressFill addSubview:self.progressBackground];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBackground
														 attribute:NSLayoutAttributeTop
														 relatedBy:NSLayoutRelationEqual
															toItem:self.progressFill
														 attribute:NSLayoutAttributeTop
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBackground
														 attribute:NSLayoutAttributeLeft
														 relatedBy:NSLayoutRelationEqual
															toItem:self.progressFill
														 attribute:NSLayoutAttributeLeft
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBackground
														 attribute:NSLayoutAttributeBottom
														 relatedBy:NSLayoutRelationEqual
															toItem:self.progressFill
														 attribute:NSLayoutAttributeBottom
														multiplier:1.0
														  constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressBackground
														 attribute:NSLayoutAttributeRight
														 relatedBy:NSLayoutRelationEqual
															toItem:self.progressFill
														 attribute:NSLayoutAttributeRight
														multiplier:1.0
														  constant:0.0]];
		
		
		
	}
	
	return self;
}

#pragma mark - RBPProgressView

- (CGFloat)progress
{
	return [RBPProgressView progressForKey:self.defaultsKey];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
	if (!animated) {
		
		[self.progressFill.layer removeAllAnimations];
		[self setProgress:progress animationDuration:0.0];
		
	} else {
		
		[self setProgress:progress animationDuration:RBPPROGRESSVIEW_ANIMATION_TIME];
		
	}
}

- (void)setProgress:(CGFloat)progress animationDuration:(CGFloat)animationDuration
{
	NSAssert(self.defaultsKey && ![self.defaultsKey isEqualToString:@""], @"RBPProgressView dataKey cannot be nil");
	
	
	[RBPProgressView setProgress:progress forKey:self.defaultsKey];
	progress = [RBPProgressView progressForKey:self.defaultsKey];
	
	
	[self layoutIfNeeded];
	
	[UIView animateWithDuration:animationDuration
						  delay:0.0
						options:(UIViewAnimationOptionAllowAnimatedContent |
								 UIViewAnimationOptionAllowUserInteraction |
								 UIViewAnimationOptionBeginFromCurrentState |
								 UIViewAnimationOptionCurveLinear)
					 animations:^{
						 
	
						 self.progressFillConstraint.constant = CGRectGetWidth(self.bounds) * progress;
						 [self layoutIfNeeded];
						 
					 }
					 completion:^(BOOL finished) {
						 
						 if (progress <= 0.0001) { // Close enough to 0
							 
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

#pragma mark - Internal

- (BOOL)isAnimating
{
	return (self.progressFill.layer.animationKeys && self.progressFill.layer.animationKeys.count > 0);
}

//TODO: REMOVE
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGFloat x = [[[touches allObjects] firstObject] locationInView:self].x;
	
	if (x < CGRectGetMidX(self.bounds))
		[self setProgress:self.progress - 0.1 animated:YES];
	else
		[self setProgress:self.progress + 0.1 animated:YES];
}

#pragma mark - Static

+ (RBPProgressView *)wellnessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:WELLNESS_DEFAULTS_KEY];
	
	bar.progressFill.backgroundColor = [UIColor redColor];
	
	return bar;
}

+ (RBPProgressView *)happinessBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:HAPPINESS_DEFAULTS_KEY];
	
	bar.progressFill.backgroundColor = [UIColor purpleColor];
	
	return bar;
}

+ (RBPProgressView *)energyBar
{
	RBPProgressView *bar = [[RBPProgressView alloc] initWithDefaultsKey:ENERGY_DEFAULTS_KEY];
	
	bar.progressFill.backgroundColor = [UIColor cyanColor];
	
	return bar;
}
				
+ (CGFloat)progressForKey:(NSString *)key
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (void)setProgress:(CGFloat)progress forKey:(NSString *)key
{
	progress = MAX(0.0, MIN(1.0, progress)); // Clamp between 0.0 and 1.0 (%)
	[[NSUserDefaults standardUserDefaults] setFloat:progress forKey:key];
}

+ (CGFloat)wellnessProgress
{
	return [self progressForKey:WELLNESS_DEFAULTS_KEY];
}

+ (void)setWellnessProgress:(CGFloat)progress
{
	[RBPProgressView setProgress:progress forKey:WELLNESS_DEFAULTS_KEY];
}

+ (CGFloat)happinessProgress
{
	return [self progressForKey:HAPPINESS_DEFAULTS_KEY];
}

+ (void)setHappinessProgress:(CGFloat)progress
{
	[RBPProgressView setProgress:progress forKey:HAPPINESS_DEFAULTS_KEY];
}

+ (CGFloat)energyProgress
{
	return [self progressForKey:ENERGY_DEFAULTS_KEY];
}

+ (void)setEnergyProgress:(CGFloat)progress
{
	[RBPProgressView setProgress:progress forKey:ENERGY_DEFAULTS_KEY];
}

@end




