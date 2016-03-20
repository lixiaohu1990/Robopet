//
//  RBPMiniGameCountdownViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//





@interface RBPMiniGameCountdownViewController : UIViewController
{
}

@property (strong, nonatomic) NSString *text;

/**
 *  Start countdown
 *
 *  @param startTime
 *  @param endTime
 *  @param update block called every second
 */
- (void)startCountdownWithSartTime:(NSInteger)startTime endTime:(NSInteger)endTime updateBlock:(void (^)(NSInteger currentTime))update;

@end




