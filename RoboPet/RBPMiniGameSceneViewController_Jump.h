//
//  RBPMiniGameSceneViewController_Jump.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import UIKit;
@import SpriteKit;

#import "RBPMiniGameSceneViewController.h"


int RobotJump;
int ScoreNumber = 0;
float BoxSpeed = 5.0;
bool onGround;
NSInteger HighScoreNumber;

@interface RBPMiniGameSceneViewController_Jump : RBPMiniGameSceneViewController
{
    IBOutlet UIImageView *Robot;
    IBOutlet UIButton *StartGame;
    IBOutlet UIImageView *Ground1;
    IBOutlet UIImageView *Ground2;
    IBOutlet UIImageView *Box;
    IBOutlet UIImageView *BiggerBox;
    IBOutlet UIButton *PlayAgain;
    IBOutlet UILabel *ScoreLabel;
    
    NSTimer *RobotMovement;
    NSTimer *BoxMovement;
    NSTimer *Ground1Movement;
    NSTimer *Ground2Movement;
    
    
}

-(IBAction)StartGame:(id)sender;
-(IBAction)PlayAgain:(id)sender;
-(void)RobotMoving;
-(void)BoxMoving;
-(void)PlaceBoxes;
-(void)Score;
-(void)GameOver;
-(void)PlaceGround1;
-(void)PlaceGround2;

@end




