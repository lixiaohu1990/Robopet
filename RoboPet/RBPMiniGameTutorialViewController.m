//
//  RBPMiniGameTutorialViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameTutorialViewController.h"

#import "RBPMiniGameTutorialPage.h"





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
	self.navigationItem.rightBarButtonItem.title = @"Play";
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	NSAssert(self.dataSource, @"RBPMiniGameTutorialViewController dataSource cannot be nil");
	
	if (self.scrollView == nil) {
		[self setupScrollView];
		[self setupPages];
	}
}

- (void)setupScrollView
{
	self.scrollView = [[UIScrollView alloc] init];
	self.scrollView.delegate = self;
	self.scrollView.bounces = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:self.scrollView];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeft
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0
														   constant:0.0]];
}

- (void)setupPages
{
	NSArray<RBPMiniGameTutorialPage *> *pages = [self.dataSource tutorialPages];
	
	self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * pages.count, CGRectGetHeight(self.view.bounds));
	self.scrollView.tag = pages.count; // Easy access to page count
	
	// Layout Pages
	for (NSUInteger pageIndex = 0; pageIndex < pages.count; pageIndex += 1) {
		
		RBPMiniGameTutorialPage *page = pages[pageIndex];
		page.frame = CGRectMake(CGRectGetWidth(self.view.bounds) * pageIndex,
								0.0,
								CGRectGetWidth(self.view.bounds),
								CGRectGetHeight(self.view.bounds));
		[self.scrollView addSubview:page];
		
	}
	
	
	// Setup PageControl
	self.pageControl = [[UIPageControl alloc] init];
	self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
	self.pageControl.numberOfPages = pages.count;
	[self.view addSubview:self.pageControl];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:[self.pageControl sizeForNumberOfPages:pages.count].width]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1.0
														   constant:[self.pageControl sizeForNumberOfPages:pages.count].height]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeCenterX
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeCenterX
														 multiplier:1.0
														   constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
														  attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
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

@end




