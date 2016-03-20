//
//  RBPMiniGamePopupViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@class RBPMiniGamePopupViewController;





@protocol RBPMiniGamePopupViewControllerDelegate <NSObject>

@required

- (void)popupViewController:(RBPMiniGamePopupViewController *)viewController didSelectOption:(NSString *)option;

@end





@interface RBPMiniGamePopupViewController : UIViewController
{
}

@property (weak, nonatomic) id<RBPMiniGamePopupViewControllerDelegate> delegate;

@property (strong, nonatomic) UIView *backgroundView;

- (void)clickedBarButton:(UIBarButtonItem *)barButtonItem;

@end




