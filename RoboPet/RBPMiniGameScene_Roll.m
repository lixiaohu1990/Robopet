//
//  RBPMiniGameScene_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

@import CoreMotion;

#import "RBPMiniGameScene_Roll.h"

typedef NS_OPTIONS(uint32_t, RBPCollisionCategory) {
    RBPCollisionCategoryPlayer = 0x1 << 0,
    RBPCollisionCategoryWall = 0x1 << 1,
	RBPCollisionCategoryBumper = 0x1 << 2,
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
@property (strong, nonatomic, readwrite) CMMotionManager *motion;

/**
 *  Array of resusable pickups
 */
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *pickups;

/**
 *  Array of reusable bumpers
 */
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *bumpers;

@end





@implementation RBPMiniGameScene_Roll

#pragma mark - Init

- (void)initialize
{
	[super initialize];
	
	self.physicsWorld.contactDelegate = self;
	
	if (self.motion){ }	// Lazy load, make sure this is created and updating
	[self setupWalls];
	[self setupPlayer];
	
    [self generatePickup];
	
	// TODO: REMOVE
	for (int x = 0; x < 4; x++) {
		[self generateBumper];
	}
}

- (void)restart
{
	[super restart];
}

- (CMMotionManager *)motion
{
	if (!_motion) {
		_motion = [[CMMotionManager alloc] init];
	}
	
	if (!_motion.accelerometerActive && _motion.accelerometerAvailable) {
		[_motion startAccelerometerUpdates];
	}
	if (!_motion.gyroActive && _motion.gyroAvailable) {
		[_motion startGyroUpdates];
	}
	
	return _motion;
}

- (void)setupWalls
{
	SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, self.size.height)];
	leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
	leftWall.physicsBody.dynamic = NO;
	leftWall.physicsBody.categoryBitMask = RBPCollisionCategoryWall;
	leftWall.physicsBody.affectedByGravity = NO;
	leftWall.position = CGPointMake(-leftWall.size.width, self.size.height / 2);
	[self addChild:leftWall];
	
	SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, self.size.height)];
	rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
	rightWall.physicsBody.dynamic = NO;
	rightWall.physicsBody.categoryBitMask = RBPCollisionCategoryWall;
	rightWall.physicsBody.affectedByGravity = NO;
	rightWall.position = CGPointMake(self.size.width + rightWall.size.width, self.size.height / 2);
	[self addChild:rightWall];
	
	SKSpriteNode *topWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 1)];
	topWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topWall.size];
	topWall.physicsBody.dynamic = NO;
	topWall.physicsBody.categoryBitMask = RBPCollisionCategoryWall;
	topWall.physicsBody.affectedByGravity = NO;
	topWall.position = CGPointMake(self.size.width / 2, self.size.height + topWall.size.height);
	[self addChild:topWall];
	
	SKSpriteNode *bottomWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 1)];
	bottomWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottomWall.size];
	bottomWall.physicsBody.dynamic = NO;
	bottomWall.physicsBody.categoryBitMask = RBPCollisionCategoryWall;
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

- (void)setupPlayer
{
	self.player = [SKSpriteNode spriteNodeWithImageNamed:@"robot_top"];
	self.player.size = CGSizeMake(self.player.size.width * 0.5, self.player.size.height * 0.5);
	
	//TODO: pick better physicsBody
	self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.height * 0.5];
	//self.player.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"robot_top"] size:self.player.size];
	
	self.player.physicsBody.allowsRotation = YES;
	self.player.physicsBody.friction = 0.7;
	self.player.physicsBody.restitution = 1.0;
	self.player.physicsBody.usesPreciseCollisionDetection = YES;
	self.player.physicsBody.categoryBitMask = RBPCollisionCategoryPlayer;
	self.player.physicsBody.contactTestBitMask = RBPCollisionCategoryWall | RBPCollisionCategoryBumper;
	self.player.physicsBody.collisionBitMask = self.player.physicsBody.contactTestBitMask;
	
	[self centrePlayer];
	[self addChild:self.player];
}

- (void)centrePlayer
{
	self.player.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
}

#pragma mark - RBPMiniGameScene_Roll

/**
 *  Generates a pickup in a random location
 */
- (void)generatePickup
{
	//TODO: check distance from player
	
	SKSpriteNode *newPickup = nil;
	
	for (SKSpriteNode *pickup in self.pickups) {		// Search for disabled cached object
		
		if (pickup.hidden == YES) {
			newPickup = pickup;
			break;
		}
		
	}
	
	if (!newPickup) {									// If no cached available, create a new one
		
		newPickup = [SKSpriteNode spriteNodeWithImageNamed:@"battery"];
		newPickup.size = CGSizeMake(newPickup.size.width * 0.35, newPickup.size.height * 0.35);
		newPickup.hidden = YES;
		// Add to scene
		[self addChild:newPickup];
		[self.pickups addObject:newPickup];
		
	}
	
	[self positionNodeRandomly:newPickup];
	//random rotation
	
	newPickup.hidden = NO;
}

/**
 *  Generates a pickup in a random location
 */
- (void)generateBumper
{
	//TODO: check distance from player
	
	SKSpriteNode *newBumper = nil;
	
	for (SKSpriteNode *bumper in self.bumpers) {		// Search for disabled cached object
		
		if (bumper.hidden == YES) {
			newBumper = bumper;
			break;
		}
		
	}
	
	if (!newBumper) {									// If no cached available, create a new one
		
		NSString *imageName = (arc4random() % 2 == 0) ? @"bumper_square" : @"bumper_triangle";
		newBumper = [SKSpriteNode spriteNodeWithImageNamed:imageName];
		
		CGFloat sizeScale = MAX(0.15, arc4random_uniform(30) / 100.0); // Random scale between x% and y%
		newBumper.size = CGSizeMake(newBumper.size.width * sizeScale, newBumper.size.height * sizeScale);
		newBumper.hidden = YES;
		
		// Setup physics
		newBumper.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:imageName] size:newBumper.size];
		newBumper.physicsBody.dynamic = NO;
		newBumper.physicsBody.categoryBitMask = RBPCollisionCategoryBumper;
		newBumper.physicsBody.affectedByGravity = NO;
		
		// Add to scene
		[self addChild:newBumper];
		[self.bumpers addObject:newBumper];
		
	}
	
	[self positionNodeRandomly:newBumper];
	
	newBumper.hidden = NO;
	// Rotate bumpers
	CGFloat randomDuration = MAX(1.0, arc4random_uniform(200) / 100.0); // Random duration between 1.0 and 2.0 seconds
	NSInteger angle = M_PI_2 * ((arc4random_uniform(2) == 1) ? 1 : -1);	// Random angle direction
	[newBumper runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:angle duration:randomDuration]]];
}

- (void)positionNodeRandomly:(SKSpriteNode *)node
{
	CGSize halfSize = CGSizeMake(node.size.width * 0.5, node.size.height * 0.5);
	
	// TODO: padding?
	NSInteger xPosition = arc4random_uniform(self.size.width);
	NSInteger yPosition = arc4random_uniform(self.size.height);
	
	// Clamp positions so pickup is never offscreen
	xPosition = MAX(halfSize.width, MIN(xPosition, self.size.width - halfSize.width));
	yPosition = MAX(halfSize.height, MIN(yPosition, self.size.height - halfSize.height));
	
	node.position = CGPointMake(xPosition, yPosition);
	NSInteger deg = arc4random() % 360;
	CGFloat rad = deg * (M_PI / 180.0);
	node.zRotation = rad;
	
	
	// Make sure newly generated node doesn't intersect player initially
	if ([self.player intersectsNode:node]) {
		[self positionNodeRandomly:node];
	}
	
	// Check for intersections of existing bumpers and pickups
	for (SKSpriteNode *bumper in self.bumpers) {
		if (node != bumper && !bumper.hidden && [node intersectsNode:bumper]) {
			[self positionNodeRandomly:node];
			return;
		}
	}
	for (SKSpriteNode *pickup in self.pickups) {
		if (node != pickup && !pickup.hidden && [node intersectsNode:pickup]) {
			[self positionNodeRandomly:node];
			return;
		}
	}
}

- (void)playerDidCollectPickup:(SKSpriteNode *)pickup
{
	pickup.hidden = YES;
	[self generatePickup];
	
	[self generateBumper];
	
	[self.progressView incrementProgress:0.3 animated:YES];
}

- (void)pulseNode:(SKNode *)node scale:(CGFloat)scale duration:(CGFloat)duration
{
	if ([node actionForKey:@"pulseScale"]) {
		return;
	}
	
	SKAction *action = [SKAction scaleTo:scale duration:duration * 0.5];
	SKAction *actionCompletion = [SKAction runBlock:^{
		[node runAction:[SKAction scaleTo:1.0 duration:duration * 0.5] withKey:@"pulseScale"];
	}];
	
	[node runAction:[SKAction sequence:@[action, actionCompletion]] withKey:@"pulseScale"];
}

- (void)pulseNode:(SKNode *)node color:(UIColor *)color duration:(CGFloat)duration
{
	if ([node actionForKey:@"pulseColor"]) {
		return;
	}
	
	SKAction *action = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.5 duration:duration * 0.5];
	SKAction *actionCompletion = [SKAction runBlock:^{
		[node runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:duration * 0.5] withKey:@"pulseScale"];
	}];
	
	[node runAction:[SKAction sequence:@[action, actionCompletion]] withKey:@"pulseColor"];
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
	[super update:currentTime];
	
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
			self.player.physicsBody.linearDamping *= 0.85;
		}
		
	}
    
    
	// *****************
	// Check for pickups
	// *****************
    for (SKSpriteNode *pickup in self.pickups) {
		if (!pickup.hidden && [self.player intersectsNode:pickup]) {
			[self playerDidCollectPickup:pickup];
        }
    }
}

#pragma mark - SKPhysicsContactDelegate

- (BOOL)isPlayerVelocityToHigh
{
	return (ABS(self.player.physicsBody.velocity.dx) > 1000 || ABS(self.player.physicsBody.velocity.dy) > 1000);
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
	if (contact.bodyA.node != self.player && contact.bodyB.node != self.player) {
		return;
	}
	
	
	if (![self isPlayerVelocityToHigh]) {
		
		CGVector collisionImpluse = CGVectorMake(contact.contactNormal.dx * contact.collisionImpulse * 0.25,
												 contact.contactNormal.dy * contact.collisionImpulse * 0.25);
		[self.player.physicsBody applyImpulse:collisionImpluse atPoint:contact.contactPoint];
		
	}
	
	self.player.physicsBody.linearDamping = MAX(1.0, self.player.physicsBody.linearDamping) * 1.75;
	//[self.progressView incrementProgress:-0.2 animated:YES];
	
	
	
	// Animated
	if (contact.bodyA.categoryBitMask == RBPCollisionCategoryBumper) {
		[self pulseNode:contact.bodyA.node scale:1.3 duration:0.4];
	} else if (contact.bodyB.categoryBitMask == RBPCollisionCategoryBumper) {
		[self pulseNode:contact.bodyB.node scale:1.3 duration:0.4];
	}
	
	[self pulseNode:self.player color:[UIColor redColor] duration:0.35];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
}

#pragma mark - Internal

- (NSMutableArray<SKSpriteNode *> *)pickups
{
    if (!_pickups) {
        _pickups = [[NSMutableArray alloc] init];
    }
    
    return _pickups;
}

- (NSMutableArray<SKSpriteNode *> *)bumpers
{
	if (!_bumpers) {
		_bumpers = [[NSMutableArray alloc] init];
	}
	
	return _bumpers;
}

@end




