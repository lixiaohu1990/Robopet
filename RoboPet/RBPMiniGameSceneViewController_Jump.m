//
//  RBPMiniGameSceneViewController_Jump.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameSceneViewController_Jump.h"

#import "RBPMiniGameScene_Jump.h"

#import "RBPMiniGameTutorialViewController.h"





@interface RBPMiniGameSceneViewController_Jump ()
{
}

@end





@implementation RBPMiniGameSceneViewController_Jump


-(IBAction)StartGame:(id)sender{
    
    StartGame.hidden = TRUE;
    onGround = TRUE;
    RobotMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(RobotMoving)
                     userInfo:nil repeats:TRUE];
    
    BoxMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(BoxMoving) userInfo:nil repeats:TRUE];
    ScoreLabel.text = [NSString stringWithFormat:@"Score:%i", ScoreNumber];
    Ground1Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground1Moving) userInfo:nil repeats:TRUE];
    Ground2Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground2Moving) userInfo:nil repeats:TRUE];


}
-(IBAction)PlayAgain:(id)sender{
    
    PlayAgain.hidden = TRUE;
    BoxSpeed = 5.0;
    RobotMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(RobotMoving)
                                                   userInfo:nil repeats:TRUE];
    
    BoxMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(BoxMoving) userInfo:nil repeats:TRUE];
    Ground1Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground1Moving) userInfo:nil repeats:TRUE];
       Ground2Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground2Moving) userInfo:nil repeats:TRUE];
    [self PlaceBoxes];
    onGround = TRUE;
    Box.hidden = FALSE;
    Robot.hidden = FALSE;
    ScoreNumber = 0;
    Ground1.hidden = FALSE;
    Ground2.hidden = FALSE;
    ScoreLabel.text = [NSString stringWithFormat:@"Score:%i", ScoreNumber];
    
    
    
}

-(void)BoxMoving{
    
    Box.center = CGPointMake(Box.center.x - BoxSpeed, Box.center.y);
    

    if( CGRectIntersectsRect(Robot.frame, Box.frame)){
        
        [self GameOver];
        
    }
    if(Box.center.x <= -10){
        [self PlaceBoxes];
    }

    
    
}
-(void)Ground1Moving{
    
    Ground1.center = CGPointMake(Ground1.center.x - BoxSpeed, Ground1.center.y);
    if(Ground1.center.x <= -323){
        [self PlaceGround1];
    }
    
    
    
}
-(void)Ground2Moving{

    Ground2.center = CGPointMake(Ground2.center.x - BoxSpeed, Ground2.center.y);
    if(Ground2.center.x <= -323){
        [self PlaceGround2];
    }


}

-(void)GameOver{
    
    [BoxMovement invalidate];
    [RobotMovement invalidate];
    PlayAgain.hidden = FALSE;
    Box.hidden = TRUE;
    Robot.hidden = TRUE;
    Ground1.hidden =TRUE;
    Ground2.hidden = TRUE;


}

-(void)Score{
    
    ScoreNumber = ScoreNumber + 1;
    
}

-(void)PlaceBoxes{
    
    Box.center = CGPointMake(670, 297);
        ScoreLabel.text = [NSString stringWithFormat:@"Score:%i", ScoreNumber];
    if (BoxSpeed != 100){
        BoxSpeed = BoxSpeed + 0.2;
    }
    
}
-(void)PlaceGround1{
    
    Ground1.center = CGPointMake(1014, 346);
    
}

-(void)PlaceGround2{
    
    Ground2.center = CGPointMake(1014, 346);
    
}

-(void)RobotMoving{
    
    Robot.center = CGPointMake(Robot.center.x, Robot.center.y - RobotJump);


    if( Robot.center.y>=292){
        
        Robot.center = CGPointMake(Robot.center.x, 293);
        
    }
    if( Robot.center.y >= 293){
        
        onGround = TRUE;
        
    }
    else if(Robot.center.y <= 292) {
        onGround = FALSE;
    }
    RobotJump = RobotJump -3.4;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    

    if(onGround == TRUE){
        RobotJump = 30;
    }

    
}


#pragma mark - Init

- (void)viewDidLoad
{
    
    PlayAgain.hidden = TRUE;
    ScoreNumber = 0;
    [super viewDidLoad];
}

- (RBPProgressView *)progressViewInternal
{
	return [RBPProgressView wellnessBar];
}

- (void)configureTutorialViewController:(RBPMiniGameTutorialViewController *)viewController
{
}

#pragma mark - RBPBaseSceneViewController

- (Class)sceneClass;
{
    return [RBPMiniGameScene_Jump class];
}

- (NSString *)backgroundImageName
{
	return @"jump_background";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RBPMiniGameTutorialViewControllerDataSource

- (NSArray<RBPMiniGameTutorialPage *> *)tutorialPages
{
	RBPMiniGameTutorialPage *pageOne = [[RBPMiniGameTutorialPage alloc] init];
	pageOne.textView.text = @"Tutorial Page 1";
	
	RBPMiniGameTutorialPage *pageTwo = [[RBPMiniGameTutorialPage alloc] init];
	pageTwo.textView.text = @"Tutorial Page 2";
	
	RBPMiniGameTutorialPage *pageThree = [[RBPMiniGameTutorialPage alloc] init];
	pageThree.textView.text = @"Tutorial Page 3";
	
	return @[pageOne, pageTwo, pageThree];
}

@end




