//
//  RBPMiniGameTutorialViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameTutorialViewController.h"





@interface RBPMiniGameTutorialViewController ()
{
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end





@implementation RBPMiniGameTutorialViewController

#pragma mark - Init

- (id)initWithDataSource:(id<RBPMiniGameTutorialViewControllerDataSource>)dataSource
{
	self = [super init];
	
	if (self) {
		self.dataSource = dataSource;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = @"Tutorial";
	self.navigationItem.leftBarButtonItem.title = @"Dont Show Again";
	self.navigationItem.rightBarButtonItem.title = @"Play";
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	NSAssert(self.dataSource, @"RBPMiniGameTutorialViewController dataSource cannot be nil");
	
	[self setupScrollView];
}
- (void)setupScrollView
{
	self.scrollView = [self.dataSource tutorialScrollView];
	
	if (!self.scrollView) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		return;
	}
	
	self.scrollView.delegate = self;
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	self.scrollView.bounces = self.scrollView.bouncesZoom = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
	[self.backgroundView addSubview:self.scrollView];
	self.scrollView.contentInset = UIEdgeInsetsZero;
	
	[self.scrollView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
																		  attribute:NSLayoutAttributeCenterX
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.scrollView.superview
																		  attribute:NSLayoutAttributeCenterX
																		 multiplier:1.0
																		   constant:0.0]];
	[self.scrollView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
																		  attribute:NSLayoutAttributeCenterY
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.scrollView.superview
																		  attribute:NSLayoutAttributeCenterY
																		 multiplier:1.0
																		   constant:0.0]];
	[self.scrollView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
																		  attribute:NSLayoutAttributeWidth
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.scrollView.superview
																		  attribute:NSLayoutAttributeWidth
																		 multiplier:1.0
																		   constant:0.0]];
	[self.scrollView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
																		  attribute:NSLayoutAttributeHeight
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.scrollView.superview
																		  attribute:NSLayoutAttributeHeight
																		 multiplier:1.0
																		   constant:0.0]];
	
	NSInteger pages = self.scrollView.subviews.count;
	self.scrollView.tag = pages;
	
	// Setup PageControl
	self.pageControl = [[UIPageControl alloc] init];
	self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
	self.pageControl.numberOfPages = pages;
	[self.backgroundView addSubview:self.pageControl];
	
	[self.pageControl.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:[self.pageControl sizeForNumberOfPages:pages].width]];
	[self.pageControl.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:[self.pageControl sizeForNumberOfPages:pages].height]];
	[self.pageControl.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.pageControl.superview
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:0.0]];
	[self.pageControl.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.pageControl.superview
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:0.0]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// Update PageControl
	CGFloat fractionalPageHorizontal = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
	self.pageControl.currentPage = lround(fractionalPageHorizontal);
	
	if (self.pageControl.currentPage == self.scrollView.tag - 1) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

#pragma mark - Internal

- (void)clickedBarButton:(UIBarButtonItem *)barButtonItem
{
	[super clickedBarButton:barButtonItem];
	
	if (barButtonItem == self.navigationItem.leftBarButtonItem) { // Don't show again
		NSString *key = [RBPMiniGameTutorialViewController showTutorialDefaultsKeyForDelegate:self.delegate];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
	}
}

+ (NSString *)showTutorialDefaultsKeyForDelegate:(id<RBPMiniGamePopupViewControllerDelegate>)delegate
{
	return [NSString stringWithFormat:@"RBPShowTutorial%@DefaultsKey", NSStringFromClass([delegate class])];
}

+ (BOOL)shouldShowTutorialForDelegate:(id<RBPMiniGamePopupViewControllerDelegate>)delegate
{
	NSString *key = [RBPMiniGameTutorialViewController showTutorialDefaultsKeyForDelegate:delegate];
	id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
	return (value == nil) ? YES : [value boolValue];
}

@end




