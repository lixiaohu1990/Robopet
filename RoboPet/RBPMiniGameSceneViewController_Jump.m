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
    RobotMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(RobotMoving)
                                                   userInfo:nil repeats:TRUE];
    
    BoxMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(BoxMoving) userInfo:nil repeats:TRUE];
    Ground1Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground1Moving) userInfo:nil repeats:TRUE];
       Ground2Movement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Ground2Moving) userInfo:nil repeats:TRUE];
    Box.center = CGPointMake(669, Box.center.y);
        Box2.center = CGPointMake(1069, Box.center.y);
        Box3.center = CGPointMake(1469 , Box.center.y);
        Box4.center = CGPointMake(1869, Box.center.y);
        Box5.center = CGPointMake(2269 , Box.center.y);
    onGround = TRUE;
    Box.hidden = FALSE;
        Box2.hidden = FALSE;
        Box3.hidden = FALSE;
        Box4.hidden = FALSE;
        Box5.hidden = FALSE;
    Robot.hidden = FALSE;
    ScoreNumber = 0;
    Ground1.hidden = FALSE;
    Ground2.hidden = FALSE;
    ScoreLabel.text = [NSString stringWithFormat:@"Score:%i", ScoreNumber];
        BoxSpeed = 5.0;
    
    
    
    
}


-(void)BoxMoving{
    
    Box.center = CGPointMake(Box.center.x - BoxSpeed, Box.center.y);
    Box2.center = CGPointMake(Box2.center.x - BoxSpeed, Box2.center.y);
    Box3.center = CGPointMake(Box3.center.x - BoxSpeed, Box3.center.y);
    Box4.center = CGPointMake(Box4.center.x - BoxSpeed, Box4.center.y);
    Box5.center = CGPointMake(Box5.center.x - BoxSpeed, Box5.center.y);
    

    if( CGRectIntersectsRect(Robot.frame, Box.frame)){
        
        [self GameOver];
        
    }
    if( CGRectIntersectsRect(Robot.frame, Box2.frame)){
        
        [self GameOver];
        
    }
    if( CGRectIntersectsRect(Robot.frame, Box3.frame)){
        
        [self GameOver];
        
    }
    if( CGRectIntersectsRect(Robot.frame, Box4.frame)){
        
        [self GameOver];
        
    }
    if( CGRectIntersectsRect(Robot.frame, Box5.frame)){
        
        [self GameOver];
        
    }
    if(Box.center.x <= -10){
        [self PlaceBoxes];
        [self Score];
        
    }
    if(Box2.center.x <= -10){
        [self PlaceBoxes2];
        [self Score];
    }
    if(Box3.center.x <= -10){
        [self PlaceBoxes3];
        [self Score];
    }
    if(Box4.center.x <= -10){
        [self PlaceBoxes4];
        [self Score];
    }
    if(Box5.center.x <= -10){
        [self PlaceBoxes5];
        [self Score];
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
    [Ground1Movement invalidate];
    [Ground2Movement invalidate];
    PlayAgain.hidden = FALSE;
    Box.hidden = TRUE;
        Box2.hidden = TRUE;
        Box3.hidden = TRUE;
        Box4.hidden = TRUE;
        Box5.hidden = TRUE;
    Robot.hidden = TRUE;
    Ground1.hidden =TRUE;
    Ground2.hidden = TRUE;


}

-(void)Score{
    
    
    ScoreNumber = ScoreNumber + 1;
    ScoreLabel.text = [NSString stringWithFormat:@"Score:%i", ScoreNumber];

    
}

-(void)PlaceBoxes{
    
    Box.center = CGPointMake(1069 + arc4random() % (2069 - 1069) , Box.center.y);

    if (BoxSpeed != 100){
        BoxSpeed = BoxSpeed + 0.2;
    }
}
-(void)PlaceBoxes2{
        
        Box2.center = CGPointMake(1469 + arc4random() % (2469 - 1469) , Box.center.y);


}
-(void)PlaceBoxes3{

            Box3.center = CGPointMake(1469 + arc4random() % (2469 - 1469)  , Box.center.y);


}
-(void)PlaceBoxes4{
                
                Box4.center = CGPointMake(1469 + arc4random() % (2469 - 1469)  , Box.center.y);


}
-(void)PlaceBoxes5{
    
                    Box5.center = CGPointMake(1469 + arc4random() % (2469 - 1469)  , Box.center.y);


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




