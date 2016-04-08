//
//  RBPMiniGameScene_Jump.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameScene_Jump.h"

typedef NS_OPTIONS(uint32_t, RBPCollisionCategory) {
    RBPCollisionCategoryNone = 0x1 << 0,
    RBPCollisionCategoryPlayer = 0x1 << 1,
    RBPCollisionCategoryBox = 0x1 << 2,
    RBPCollisionCategoryFloor = 0x1 << 3,
};

int speed;
int score;
bool canJump;

@interface RBPMiniGameScene_Jump() <SKPhysicsContactDelegate>
{
}

@property (strong, nonatomic) SKSpriteNode *ground1;
@property (strong, nonatomic) SKSpriteNode *ground2;
@property (strong, nonatomic) SKSpriteNode *ground3;
@property (strong, nonatomic) SKSpriteNode *box;
@property (strong, nonatomic) SKSpriteNode *box1;
@property (strong, nonatomic) SKSpriteNode *box2;
@property (strong, nonatomic) SKSpriteNode *box3;
@property (strong, nonatomic) SKSpriteNode *box4;
@property (strong, nonatomic) SKSpriteNode *robot;

@property (strong, nonatomic) SKAction *action_death;
@property (strong, nonatomic) SKAction *action_jump;

@property (strong, nonatomic) SKAction *rotate1;





@end





@implementation RBPMiniGameScene_Jump

#pragma mark - Init

+ (instancetype)sceneWithSize:(CGSize)size
{
    RBPMiniGameScene_Jump *scene = [super sceneWithSize:size];
    
    if (scene) { // Preload assets
        
        scene.action_death = [SKAction playSoundFileNamed:@"Sounds/roll_battery.caf" waitForCompletion:NO];
        scene.action_jump = [SKAction playSoundFileNamed:@"Sounds/roll_bumper.caf" waitForCompletion:NO];

        
    }
    
    return scene;
}


- (void)initialize
{
    [super initialize];
	
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
    
    // Setup view here
    
    
    self.ground1 = [SKSpriteNode spriteNodeWithImageNamed:@"jump_ground"];
    self.ground1.anchorPoint = CGPointZero;
    self.ground1.size = CGSizeMake(self.size.width, self.ground1.size.height);
    self.ground1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.ground1.size.width*20, self.ground1.size.height*2)];
    self.ground1.physicsBody.dynamic = NO;
    [self addChild:self.ground1];
    //self.ground2 = [SKSpriteNode spriteNodeWithImageNamed:@"jump_ground"];
    //  self.ground2.size = CGSizeMake(self.ground2.size.width, self.ground2.size.height);
    //    self.ground2.position = CGPointMake(self.frame.size.width*2, 100);
    //  self.ground2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.ground2.size.width, self.ground2.size.height)];
    //   self.ground2.physicsBody.dynamic = NO;
    //   [self addChild:self.ground2];

    
    
    
    self.box = [SKSpriteNode spriteNodeWithImageNamed:@"jumpblock"];
    self.box1.size = CGSizeMake(self.box1.size.width, self.box1.size.height);
    self.box.hidden = YES;
    self.box1 = [SKSpriteNode spriteNodeWithImageNamed:@"jumpblock"];
    self.box1.position = CGPointMake(self.frame.size.width, 260);
    self.box1.size = CGSizeMake(self.box1.size.width, self.box1.size.height);
    self.box1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.box1.size.width, self.box1.size.height)];
    self.box1.physicsBody.dynamic = YES;
    self.box1.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
    self.box1.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
    self.box1.physicsBody.allowsRotation = NO;
    [self addChild:self.box1];
    self.box2 = [SKSpriteNode spriteNodeWithImageNamed:@"virus"];
    self.box2.position = CGPointMake(self.frame.size.width + 1000, 260);
    self.box2.size = CGSizeMake(self.box2.size.width, self.box2.size.height);
    self.box2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.box2.size.width/2];
    self.box2.physicsBody.dynamic = YES;
    self.box2.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
    self.box2.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
    self.box2.physicsBody.allowsRotation = NO;
    [self addChild:self.box2];
    self.box3 = [SKSpriteNode spriteNodeWithImageNamed:@"jumpblock"];
    self.box3.position = CGPointMake(self.frame.size.width + 2000, 260);
    self.box3.size = CGSizeMake(self.box3.size.width, self.box3.size.height);
    self.box3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.box3.size.width, self.box3.size.height)];
    self.box3.physicsBody.dynamic = YES;
    self.box3.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
    self.box3.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
    self.box3.physicsBody.allowsRotation = NO;
    [self addChild:self.box3];
    self.box4 = [SKSpriteNode spriteNodeWithImageNamed:@"virus"];
    self.box4.position = CGPointMake(self.frame.size.width + 3000, 260);
    self.box4.size = CGSizeMake(self.box4.size.width, self.box4.size.height);
    self.box4.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.box4.size.width/2];
    self.box4.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
    self.box4.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
    self.box4.physicsBody.dynamic = YES;
    self.box4.physicsBody.allowsRotation = NO;
    
    speed = 0;
    score = 0;
    canJump = YES;
    [self addChild:self.box4];
    
    [self loadPlayer];
}



-(void)loadPlayer{
    self.robot = [SKSpriteNode spriteNodeWithImageNamed:@"robot_side_whole"];
    self.robot.position = CGPointMake(self.frame.size.width/7, 320);
    self.robot.size = CGSizeMake(self.robot.size.width, self.robot.size.height);
    self.robot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.robot.size];
    self.robot.physicsBody.dynamic = YES;
    self.robot.physicsBody.mass = 10.0;
    self.robot.physicsBody.affectedByGravity = YES;
    self.robot.physicsBody.allowsRotation = NO;
    self.robot.physicsBody.usesPreciseCollisionDetection = YES;
    self.robot.physicsBody.contactTestBitMask = RBPCollisionCategoryBox;
    self.robot.physicsBody.categoryBitMask = RBPCollisionCategoryPlayer;
    self.robot.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryBox;
    [self addChild:self.robot];
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(canJump == YES){
        self.robot.physicsBody.velocity = CGVectorMake(0.0, 800);
        [RBPSoundManager runSoundAction:self.action_jump onNode:self.robot];
    }

    
}


-(void) moveBoxes{
    self.box1.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    self.box2.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    self.box3.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    self.box4.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    
}

-(void) moveGround{

    self.ground1.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    self.ground2.physicsBody.velocity = CGVectorMake(-300 - speed, 0);
    
}

-(void) placeBoxes{
    if(self.box1.position.x <= 0){

        
        speed = speed + 2;
        srand( (unsigned int)time(0) );
        float randomNumber = rand() % 3 + 1.7;
        self.box1.size = CGSizeMake(self.box.size.width*randomNumber/2, self.box.size.height*randomNumber/2);
        self.box1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.box1.size.width, self.box1.size.height)];
        self.box1.physicsBody.dynamic = YES;
        self.box1.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
        self.box1.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
        self.box1.physicsBody.allowsRotation = NO;
        score = score+1;
        randomNumber = randomNumber * 100;
        int randomBool = rand() % 2 + 1;
        if(randomBool == 1){
            self.box1.position = CGPointMake(self.box4.position.x + 1000 + randomNumber, 260);
        }
        else {
            self.box1.position = CGPointMake(self.box4.position.x + 1000 - randomNumber, 260);
        }
    }
    if(self.box2.position.x <= 0){

		speed = speed + 2;
		srand( (unsigned int)time(0) );
        float randomNumber = rand() % 3 + 1.7;
        self.box2.size = CGSizeMake(self.box.size.width*randomNumber/2, self.box.size.height*randomNumber/2);
    self.box2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.box.size.width*randomNumber/4];
        self.box2.physicsBody.dynamic = YES;
        self.box2.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
        self.box2.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
        self.box2.physicsBody.allowsRotation = NO;
        score = score+1;
        randomNumber = randomNumber * 100;
        int randomBool = rand() % 2 + 1;
        if(randomBool == 1){
            self.box2.position = CGPointMake(self.box1.position.x + 1000 + randomNumber, 260);
        }
        else {
            self.box2.position = CGPointMake(self.box1.position.x + 1000 - randomNumber, 260);
        }
    }
    if(self.box3.position.x <= 0){

		speed = speed + 2;
		srand( (unsigned int)time(0) );
        float randomNumber = rand() % 3 + 1.7;
        self.box3.size = CGSizeMake(self.box.size.width*randomNumber/2, self.box.size.height*randomNumber/2);
        self.box3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.box3.size.width, self.box3.size.height)];
        self.box3.physicsBody.dynamic = YES;
        self.box3.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
        self.box3.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
        self.box3.physicsBody.allowsRotation = NO;
        score = score+1;
        randomNumber = randomNumber * 100;
        int randomBool = rand() % 2 + 1;
        if(randomBool == 1){
            self.box3.position = CGPointMake(self.box2.position.x + 1000 + randomNumber, 260);
        }
        else {
            self.box3.position = CGPointMake(self.box2.position.x + 1000 - randomNumber, 260);
        }
    }
    if(self.box4.position.x <= 0){
		
		speed = speed + 2;
		srand( (unsigned int)time(0) );
        float randomNumber = rand() % 3 + 1.7;
        self.box4.size = CGSizeMake(self.box.size.width*randomNumber/2, self.box.size.height*randomNumber/2);
    self.box4.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.box.size.width*randomNumber/4];
        self.box4.physicsBody.dynamic = YES;
        self.box4.physicsBody.categoryBitMask = RBPCollisionCategoryBox;
        self.box4.physicsBody.collisionBitMask = RBPCollisionCategoryFloor | ~RBPCollisionCategoryPlayer;
        self.box4.physicsBody.allowsRotation = NO;
        score = score+1;
        randomNumber = randomNumber * 100;
        int randomBool = rand() % 2 + 1;
        if(randomBool == 1){
            self.box4.position = CGPointMake(self.box3.position.x + 1000 + randomNumber, 260);
        }
        else {
            self.box4.position = CGPointMake(self.box3.position.x + 1000 - randomNumber, 260);
        }
    }
}

-(void) canJump {
    
    if(self.robot.position.y > 320){
        canJump = NO;
    }
    else {
        canJump = YES;
    }
}

-(void) stopBouncing{
    if(self.robot.position.y == 317) {
        self.robot.physicsBody.velocity = CGVectorMake(0.0,0.0);
    }
}


- (void)restart
{
    [super restart];
}

-(void) checkDead{
    
    if ([self.robot intersectsNode:self.box1]) {
        
        if ([RBPSoundManager soundEnabled]) {
            
            [self runAction:self.action_death completion:^{
				[self endMinigame];
            }];
            
        } else {
           [self endMinigame];
        }
        
        
        
    }
    if ([self.robot intersectsNode:self.box2]) {
        
        
        if ([RBPSoundManager soundEnabled]) {
            
            [self runAction:self.action_death completion:^{
                [self endMinigame];
            }];
            
        } else {
            [self endMinigame];
        }
        
    }
    if ([self.robot intersectsNode:self.box3]) {
        
        
        if ([RBPSoundManager soundEnabled]) {
            
            [self runAction:self.action_death completion:^{
				[self endMinigame];
            }];
            
        } else {
            [self endMinigame];
        }
        
    }
    if ([self.robot intersectsNode:self.box4]) {
        
        if ([RBPSoundManager soundEnabled]) {
            
            [self runAction:self.action_death completion:^{
                [self endMinigame];
            }];
            
        } else {
            [self endMinigame];
        }
        
    }
    
}

#pragma mark - RBPMiniGameScene

- (NSString *)minigameName
{
	return @"Leap Virus";
}

- (void)setScore:(CGFloat)score
{
    [super setScore:score];
    
    //self.difficultyLevel = (score / 3) + 1;
//    self.difficultyLevel = score + 1;
}

- (void)setDifficultyLevel:(NSUInteger)difficultyLevel
{
    [super setDifficultyLevel:difficultyLevel];
}

- (NSString *)gameOverMessage
{
	if (self.score > 0.0 && self.score >= self.highScore) {
		return [NSString stringWithFormat:@"NEW HIGH SCORE!!!\n\n%lu", (NSInteger)self.score];
	}
	
	return [NSString stringWithFormat:@"Score:%lu\nHigh Score:%lu", (NSInteger)self.score, (NSInteger)self.highScore];
}




#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
    self.physicsWorld.gravity = CGVectorMake(0, -5.0);
    [super update:currentTime];
    [self moveBoxes];
    [self moveGround];
    [self placeBoxes];
    [self canJump];
    //[self stopBouncing];
    [self checkDead];
    [super setScore:score];
    SKAction *rotation1 = [SKAction rotateByAngle: M_PI/30.0 duration:0];
    [self.box2 runAction: rotation1];
    [self.box4 runAction: rotation1];
    
    
    
    
}

@end