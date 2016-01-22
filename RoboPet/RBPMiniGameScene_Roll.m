//
//  RBPMiniGameScene_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

@import CoreMotion;

#import "RBPMiniGameScene_Roll.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryWall = 0x1 << 1
};





@interface RBPMiniGameScene_Roll() <SKPhysicsContactDelegate>
{
}

@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) CMMotionManager *motion;

@end





@implementation RBPMiniGameScene_Roll

#pragma mark - SKScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
   self.physicsWorld.contactDelegate = self;
    
    
    // Setup motion data
    self.motion = [[CMMotionManager alloc] init];
    [self.motion startAccelerometerUpdates];
    [self.motion startGyroUpdates];
    
    
    // Setup player
    self.player = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
    self.player.physicsBody.allowsRotation = NO;
    self.player.physicsBody.friction = 0.5;
    self.player.physicsBody.restitution = 1.0;
    self.player.physicsBody.usesPreciseCollisionDetection = YES;
    self.player.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    self.player.physicsBody.collisionBitMask = CollisionCategoryWall;
    self.player.physicsBody.contactTestBitMask = CollisionCategoryWall;
    
    // Start in centre
    self.player.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:self.player];
    
    
    // Setup walls
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, self.size.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.physicsBody.categoryBitMask = CollisionCategoryWall;
    leftWall.physicsBody.affectedByGravity = NO;
    leftWall.position = CGPointMake(-leftWall.size.width, self.size.height / 2);
    [self addChild:leftWall];
    
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, self.size.height)];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.physicsBody.categoryBitMask = CollisionCategoryWall;
    rightWall.physicsBody.affectedByGravity = NO;
    rightWall.position = CGPointMake(self.size.width + rightWall.size.width, self.size.height / 2);
    [self addChild:rightWall];
    
    SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 1)];
    topWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topWall.size];
    topWall.physicsBody.dynamic = NO;
    topWall.physicsBody.categoryBitMask = CollisionCategoryWall;
    topWall.physicsBody.affectedByGravity = NO;
    topWall.position = CGPointMake(self.size.width / 2.0, self.size.height + topWall.size.height);
    [self addChild:topWall];
    
    SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 1)];
    bottomWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomWall.size];
    bottomWall.physicsBody.dynamic = NO;
    bottomWall.physicsBody.categoryBitMask = CollisionCategoryWall;
    bottomWall.physicsBody.affectedByGravity = NO;
    bottomWall.position = CGPointMake(self.size.width / 2, -bottomWall.size.height);
    [self addChild:bottomWall];
    
}

- (void)update:(CFTimeInterval)currentTime
{
    // Apply impulse force in the opposite direction of the gyroscope for precise deceleration control
    CGVector impulseVector = CGVectorMake(-self.motion.gyroData.rotationRate.x, -self.motion.gyroData.rotationRate.y);
    
    if (ABS(impulseVector.dx) < 0.4) { impulseVector.dx = 0.0; }
    if (ABS(impulseVector.dy) < 0.4) { impulseVector.dy = 0.0; }
    
    // Modify gravity based on accelerometer to move the player
    CGVector gravityVector = CGVectorMake(self.motion.accelerometerData.acceleration.y * 9.8,
                                       self.motion.accelerometerData.acceleration.x * -9.8);
    
    
    // Apply new forces
    [self.player.physicsBody applyImpulse:impulseVector];
    self.physicsWorld.gravity = gravityVector;
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    CGVector collisionImpluse = CGVectorMake(contact.contactNormal.dx * contact.collisionImpulse,
//                                             contact.contactNormal.dy * contact.collisionImpulse);
//    [self.player.physicsBody applyImpulse:collisionImpluse atPoint:contact.contactPoint];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
}

@end




