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
    CollisionCategoryWall = 0x1 << 1,
};





@interface RBPMiniGameScene_Roll() <SKPhysicsContactDelegate>
{
}

@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) CMMotionManager *motion;

@property (strong, nonatomic) NSMutableArray *pickups;

@end





@implementation RBPMiniGameScene_Roll

#pragma mark - Init

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
    self.player.physicsBody.contactTestBitMask = CollisionCategoryWall;
    //self.player.physicsBody.collisionBitMask = ;
    
    // Start in centre
    self.player.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:self.player];
	
	[self setupWalls];
	
    [self generatePickup];
}

- (void)setupWalls
{
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
	topWall.position = CGPointMake(self.size.width / 2, self.size.height + topWall.size.height);
	[self addChild:topWall];
	
	SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 1)];
	bottomWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomWall.size];
	bottomWall.physicsBody.dynamic = NO;
	bottomWall.physicsBody.categoryBitMask = CollisionCategoryWall;
	bottomWall.physicsBody.affectedByGravity = NO;
	bottomWall.position = CGPointMake(self.size.width / 2, -bottomWall.size.height);
	[self addChild:bottomWall];
	
	
	// Setup particles
	SKEmitterNode *leftWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
	leftWallParticles.position = leftWall.position;
	leftWallParticles.zRotation = M_PI_2;
	leftWallParticles.targetNode = self.scene;
	[self addChild:leftWallParticles];
	
	SKEmitterNode *rightWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
	rightWallParticles.position = rightWall.position;
	rightWallParticles.zRotation = M_PI_2;
	rightWallParticles.targetNode = self.scene;
	[self addChild:rightWallParticles];
	
	SKEmitterNode *topWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
	topWallParticles.position = topWall.position;
	topWallParticles.zRotation = M_PI;
	topWallParticles.targetNode = self.scene;
	[self addChild:topWallParticles];
	
	SKEmitterNode *bottomWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
	bottomWallParticles.position = bottomWall.position;
	bottomWallParticles.zRotation = M_PI;
	bottomWallParticles.targetNode = self.scene;
	[self addChild:bottomWallParticles];
}

#pragma mark - RBPMiniGameScene_Roll

/**
 *  Generates a pickup in a random location
 */
- (void)generatePickup
{
	//TODO: check distance from player
	
    // Instantiate pickup
    SKSpriteNode *pickup = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(100, 100)];
	CGSize pickupHalfSize = CGSizeMake(pickup.size.width / 2, pickup.size.height / 2);
	
    // Generate random position
	// TODO: padding?
	CGFloat xPosition = arc4random_uniform(self.size.width);
	CGFloat yPosition = arc4random_uniform(self.size.height);
	// Clamp positions so pickup is never offscreen
	xPosition = MIN(xPosition, self.size.width - pickupHalfSize.width);
	xPosition = MAX(xPosition, pickupHalfSize.width);
	yPosition = MIN(yPosition, self.size.height - pickupHalfSize.height);
	yPosition = MAX(yPosition, pickupHalfSize.height);
	
	
    pickup.position = CGPointMake(xPosition, yPosition);
    
    // Add to scene
    [self addChild:pickup];
    [self.pickups addObject:pickup];
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
    // Apply impulse force in the opposite direction of the gyroscope for precise deceleration control
    CGVector impulseVector = CGVectorMake(self.motion.gyroData.rotationRate.x, self.motion.gyroData.rotationRate.y);
    
    if (ABS(impulseVector.dx) < 0.5) { impulseVector.dx = 0.0; }
    if (ABS(impulseVector.dy) < 0.5) { impulseVector.dy = 0.0; }
    
    // Modify gravity based on accelerometer to move the player
    CGVector gravityVector = CGVectorMake(self.motion.accelerometerData.acceleration.y * -9.8,
                                       self.motion.accelerometerData.acceleration.x * 9.8);
    
    
    // Apply new forces
    [self.player.physicsBody applyImpulse:impulseVector];
    self.physicsWorld.gravity = gravityVector;
    
    
    // Check pickup intersection
    for (SKNode *pickup in self.pickups) {
        if ([self.player intersectsNode:pickup]) {
            [pickup removeFromParent];
            [self.pickups removeObject:pickup];
            [self generatePickup];
        }
    }
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

#pragma mark - Internal

- (NSMutableArray *)pickups
{
    if (!_pickups) {
        _pickups = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _pickups;
}

@end




