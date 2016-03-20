//
//  RBPMiniGameTutorialViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBPMiniGamePopupViewController.h"

@class RBPMiniGameTutorialPage;





@protocol RBPMiniGameTutorialViewControllerDataSource <NSObject>

@required

/**
 *  Return the scrollview containing your tutorial pages
 *
 *  @return UIScrollView
 */
- (UIScrollView *)tutorialScrollView;

@end





@interface RBPMiniGameTutorialViewController : RBPMiniGamePopupViewController <UIScrollViewDelegate>
{
}

- (id)initWithDataSource:(id<RBPMiniGameTutorialViewControllerDataSource>)dataSource;

@property (weak, nonatomic) id<RBPMiniGameTutorialViewControllerDataSource> dataSource;

+ (BOOL)shouldShowTutorialForDelegate:(id<RBPMiniGamePopupViewControllerDelegate>)delegate;

@end




