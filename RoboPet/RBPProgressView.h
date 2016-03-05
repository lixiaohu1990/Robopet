//
//  RBPProgressView.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RBPProgressView : UIView
{
}

- (id)initWithDefaultsKey:(NSString *)defaultsKey;

/**
 *  NSUserDefaults key for this bars progress level
 */
@property (strong, nonatomic) NSString *defaultsKey;

/**
 *  The progress value when this RBPProgressView was initialized
 */
@property (readonly, nonatomic) CGFloat initialProgress;
/**
 *  The current progress value
 */
@property (readonly, nonatomic) CGFloat progress;

/**
 *  Set progress value
 *
 *  @param progress
 *  @param animated
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/**
 *  Increment progress value
 *
 *  @param increment
 *  @param animated
 */
- (void)incrementProgress:(CGFloat)increment animated:(BOOL)animated;

/**
 *  Instantiate a RBPProgressView linked to the wellness level
 *
 *  @return RBPProgressView
 */
+ (RBPProgressView *)wellnessBar;

/**
 *  Instantiate a RBPProgressView linked to the happiness level
 *
 *  @return RBPProgressView
 */
+ (RBPProgressView *)happinessBar;

/**
 *  Instantiate a RBPProgressView linked to the energy level
 *
 *  @return RBPProgressView
 */
+ (RBPProgressView *)energyBar;

@end




