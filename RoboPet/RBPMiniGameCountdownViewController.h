//
//  RBPMiniGameCountdownViewController.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-08.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RBPMiniGameCountdownViewController : UIViewController
{
}

- (void)startCountdownWithSartTime:(NSInteger)startTime endTime:(NSInteger)endTime updateBlock:(void (^)(NSInteger currentTime))update;

@end




