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

/**
 *  Player node
 */
@property (strong, nonatomic) SKSpriteNode *player;

/**
 *  Device motion data manager
 */
@property (strong, nonatomic) CMMotionManager *motion;

/**
 *  Array of resusable pickups
 */
@property (strong, nonatomic) NSMutableArray *pickups;

@end





@implementation RBPMiniGameScene_Roll

#pragma mark - Init

- (void)initialize
{
	[super initialize];
	
	
	self.physicsWorld.contactDelegate = self;
    
    
    // Setup motion data
    self.motion = [[CMMotionManager alloc] init];
    [self.motion startAccelerometerUpdates];
    [self.motion startGyroUpdates];

    
    // Setup player
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"robot_top"];
	self.player.size = CGSizeMake(self.player.size.width * 0.5, self.player.size.height * 0.5);
	self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.height / 2.0];//[UIScreen mainScreen].scale];
    self.player.physicsBody.allowsRotation = YES;
    self.player.physicsBody.friction = 0.7;
    self.player.physicsBody.restitution = 1.0;
    self.player.physicsBody.usesPreciseCollisionDetection = YES;
    self.player.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    self.player.physicsBody.contactTestBitMask = CollisionCategoryWall;
    //self.player.physicsBody.collisionBitMask = ;
    self.player.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    [self addChild:self.player];
	
	
	[self setupWalls];
	
	
    [self generatePickup];
}

- (void)restart
{
	[super restart];
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
	
	
	
	
	
	
	
	//self.physicsWorld.gravity = CGVectorMake(0, 0);
	
	// Setup particles
//	SKEmitterNode *leftWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
//	leftWallParticles.position = leftWall.position;
//	leftWallParticles.zRotation = M_PI_2;
//	[self addChild:leftWallParticles];
//	
//	SKEmitterNode *rightWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
//	rightWallParticles.position = rightWall.position;
//	rightWallParticles.zRotation = M_PI_2;
//	[self addChild:rightWallParticles];
//	
//	SKEmitterNode *topWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
//	topWallParticles.position = topWall.position;
//	topWallParticles.zRotation = M_PI;
//	[self addChild:topWallParticles];
//	
//	SKEmitterNode *bottomWallParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"]];
//	bottomWallParticles.position = bottomWall.position;
//	bottomWallParticles.zRotation = M_PI;
//	[self addChild:bottomWallParticles];
}

#pragma mark - RBPMiniGameScene_Roll

/**
 *  Generates a pickup in a random location
 */
- (void)generatePickup
{
	//TODO: check distance from player
	
    // Instantiate pickup
	
	SKSpriteNode *newPickup = nil;
	
	// Search for disabled pickup
	for (SKSpriteNode *pickup in self.pickups) {
		
		if (pickup.hidden == YES) {
			newPickup = pickup;
			break;
		}
		
	}
	
	// If no disabled pick, create a new one
	if (!newPickup) {
		
		newPickup = [SKSpriteNode spriteNodeWithImageNamed:@"battery"];
		newPickup.size = CGSizeMake(newPickup.size.width * 0.5, newPickup.size.height * 0.5);
		newPickup.hidden = YES;
		// Add to scene
		[self addChild:newPickup];
		[self.pickups addObject:newPickup];
		
	}
	
	
	// Generate random position
	CGSize pickupHalfSize = CGSizeMake(newPickup.size.width * 0.5, newPickup.size.height * 0.5);
	
	// TODO: padding?
	CGFloat xPosition = arc4random_uniform(self.size.width);
	CGFloat yPosition = arc4random_uniform(self.size.height);
	
	// Clamp positions so pickup is never offscreen
	xPosition = MAX(pickupHalfSize.width, MIN(xPosition, self.size.width - pickupHalfSize.width));
	yPosition = MAX(pickupHalfSize.height, MIN(yPosition, self.size.height - pickupHalfSize.height));
	
    newPickup.position = CGPointMake(xPosition, yPosition);
	newPickup.hidden = NO;
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
	[super update:currentTime];
	
	// only incremental decrease when we aren't at a high velocity
//	if (![self.progressView isAnimating]) {
//		[self.progressView incrementProgress:-0.15 animationDuration:3.0];
//	}
	
	
	// *****************
	// Rotate player
	// *****************
	
	// Legs of triangle for rotation calculation
	CGFloat adjacent = self.player.position.x - (10.0 * -self.player.physicsBody.velocity.dx);
	CGFloat opposite = self.player.position.y - (10.0 * self.player.physicsBody.velocity.dy);
	
	CGFloat angle = atan2(opposite, adjacent);
	angle = -angle - M_PI_2; // iOS starts in different quadrant
	
	[self.player runAction:[SKAction rotateToAngle:angle duration:0.15 shortestUnitArc:YES]];
	
	// SKAction seems to handle this internally
//	CGFloat deltaAngle = angle - self.player.zRotation;
//	if (ABS(deltaAngle) > M_PI_2) { // clamp large angle changes for smooth rotations
//		deltaAngle = copysign(0.005, -deltaAngle); //preserve direction
//		angle += deltaAngle;
//	}
//	self.player.rotationz = angle
	
	
	
	
	// ****************
    // Apply new forces
	// ****************
	
	// Apply impulse force in the opposite direction of the gyroscope for precise deceleration control
	CGVector impulseVector = CGVectorMake(self.motion.gyroData.rotationRate.x, self.motion.gyroData.rotationRate.y);
	
	if (ABS(impulseVector.dx) < 0.5) { impulseVector.dx = 0.0; }
	if (ABS(impulseVector.dy) < 0.5) { impulseVector.dy = 0.0; }
	
	// Modify gravity based on accelerometer to move the player
	CGVector gravityVector = CGVectorMake(self.motion.accelerometerData.acceleration.y * -9.8,
										  self.motion.accelerometerData.acceleration.x * 9.8);
	
    [self.player.physicsBody applyImpulse:impulseVector];
    self.physicsWorld.gravity = gravityVector;
	
	if (![self isPlayerVelocityToHigh]) { // start allowing larger velocity once it is under control
		
		if (self.player.physicsBody.linearDamping > 0.1) {
			self.player.physicsBody.linearDamping -= 0.05;
		}
		
	}
    
    
	// *****************
	// Check for pickups
	// *****************
    for (SKNode *pickup in self.pickups) {
		
		if (!pickup.hidden && [self.player intersectsNode:pickup]) { // Did collect pickup
			
			[self.progressView incrementProgress:0.3 animated:YES];
			
			pickup.hidden = YES;
            [self generatePickup];
			
        }
		
    }
}

#pragma mark - SKPhysicsContactDelegate

- (BOOL)isPlayerVelocityToHigh
{
	return (ABS(self.player.physicsBody.velocity.dx) > 3000 || ABS(self.player.physicsBody.velocity.dy) > 3000);
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
	if (![self isPlayerVelocityToHigh]) {
		
		CGVector collisionImpluse = CGVectorMake(contact.contactNormal.dx * contact.collisionImpulse * 0.25,
												 contact.contactNormal.dy * contact.collisionImpulse * 0.25);
		[self.player.physicsBody applyImpulse:collisionImpluse atPoint:contact.contactPoint];
		
	}
	
	self.player.physicsBody.linearDamping = MAX(1.0, self.player.physicsBody.linearDamping) * 1.75;
	[self.progressView incrementProgress:-0.2 animated:YES];
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




