//
//  RBPMiniGameScene_Roll.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

@import CoreMotion;

#import "RBPMiniGameScene_Roll.h"

#import "RBPMiniGameRollBattery.h"
#import "RBPMiniGameRollBumper.h"





typedef NS_OPTIONS(uint32_t, RBPCollisionCategory) {
	RBPCollisionCategoryNone = 0x1 << 0,
    RBPCollisionCategoryPlayer = 0x1 << 1,
    RBPCollisionCategoryWall = 0x1 << 2,
	RBPCollisionCategoryBumper = 0x1 << 3,
};





@interface RBPMiniGameScene_Roll() <SKPhysicsContactDelegate>
{
}

/**
 *  Player node
 */
@property (strong, nonatomic) SKSpriteNode *player;
/**
 *  Invisible node to rotate player to
 */
@property (strong, nonatomic) SKSpriteNode *playerRotationNode;

/**
 *  Array of walls
 */
@property (strong, nonatomic) NSArray *walls;

/**
 *  Device motion data manager
 */
@property (strong, nonatomic, readwrite) CMMotionManager *motion;

/**
 *  Array of resusable pickups
 */
@property (strong, nonatomic) NSMutableArray *pickups;

/**
 *  Array of reusable bumpers
 */
@property (strong, nonatomic) NSMutableArray *bumpers;

/**
 *  Operation to generate bumpers with a delay, to make sure it doesn't happen twice
 */
@property (strong, nonatomic) NSMutableArray *generateBumperOperations;


// Preloaded assets

@property (strong, nonatomic) SKAction *action_BumperCollisionSound;
@property (strong, nonatomic) SKAction *action_PickupSound;

@end





@implementation RBPMiniGameScene_Roll

#pragma mark - Init

+ (instancetype)sceneWithSize:(CGSize)size
{
	RBPMiniGameScene_Roll *scene = [super sceneWithSize:size];
	
	if (scene) { // Preload assets
		
		scene.action_BumperCollisionSound = [SKAction playSoundFileNamed:@"Sounds/roll_bumper.caf" waitForCompletion:NO];
		scene.action_PickupSound = [SKAction playSoundFileNamed:@"Sounds/roll_battery.caf" waitForCompletion:NO];
		
	}
	
	return scene;
}

- (void)initialize
{
	[super initialize];
	
	self.physicsWorld.contactDelegate = self;
	
	if (self.motion){ }	// Lazy load, make sure this is created and updating
	[self setupWalls];
	[self setupPlayer];
	
	[self generatePickup];
	[self generateBumpersForDifficulty:self.difficultyLevel minDelay:0.0 maxDelay:0.0];
}

- (void)restart
{
	for (NSOperation *operation in self.generateBumperOperations) {
		[operation cancel];
	}
	[self.generateBumperOperations removeAllObjects];
	
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
	
	self.walls = @[leftWall, rightWall, topWall, bottomWall];
}

- (void)setupPlayer
{
	self.player = [SKSpriteNode spriteNodeWithImageNamed:@"robot_top"];
	self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.height * 0.5];
	
	self.player.physicsBody.allowsRotation = YES;
	self.player.physicsBody.mass = 100000;
	self.player.physicsBody.friction = 0.7;
	self.player.physicsBody.restitution = 1.0;
	self.player.physicsBody.usesPreciseCollisionDetection = YES;
	self.player.physicsBody.categoryBitMask = RBPCollisionCategoryPlayer;
	self.player.physicsBody.contactTestBitMask = RBPCollisionCategoryWall | RBPCollisionCategoryBumper;
	self.player.physicsBody.collisionBitMask = self.player.physicsBody.contactTestBitMask;
	
	[self centrePlayer];
	[self addChild:self.player];
	
	
	self.playerRotationNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(25, 25)];
	[self addChild:self.playerRotationNode];
	
	SKConstraint *constraint = [SKConstraint orientToNode:self.playerRotationNode offset:[SKRange rangeWithConstantValue:-M_PI_2]];
	constraint.referenceNode = self.scene;
	self.player.constraints = @[constraint];
	
}

- (void)centrePlayer
{
	self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
}

#pragma mark - RBPMiniGameScene_Roll

/**
 *  Generates a pickup in a random location
 */
- (void)generatePickup
{
	__block RBPMiniGameRollBattery *newPickup = nil;
	
	[self.pickups enumerateObjectsUsingBlock:^(RBPMiniGameRollBattery *obj, NSUInteger idx, BOOL *stop) {
		if (!obj.parent) {
			newPickup = obj;
			stop = (BOOL *)YES;
		}
	}];
	
	if (!newPickup) {
		
		newPickup = [[RBPMiniGameRollBattery alloc] init];
		
	}
	
	
	
	
	
	void (^pickupPositioned)(RBPMiniGameRollBattery *pickup) = ^(RBPMiniGameRollBattery *pickup){
		
		pickup.alpha = 0.0;
		
		[self.pickups addObject:pickup];
		
		[pickup runAction:[SKAction fadeAlphaTo:1.0 duration:0.25] completion:^{
			[pickup startDrainWithDuration:[self batteryDrainDurationForDifficulty:self.difficultyLevel]
								   completion:^(RBPMiniGameRollBattery *battery) {
									   [battery removeFromParent];
									   [self endMinigame];
								   }];
		}];
		
	};
	
	
	
	
	if ([self randomlyPositionNode:newPickup attemptCount:0]) {
		
		pickupPositioned(newPickup);
		
	} else { // Failed to find a random position, so remove a bumper and position it there
		
		for (SKNode *node in self.children) {
			if ([node isKindOfClass:[RBPMiniGameRollBumper class]]) {
				
				newPickup.position = node.position;
				pickupPositioned(newPickup);
				[node removeFromParent];
				
				break;
			}
		}
		
	}
}

/**
 *  Generates a pickup in a random location
 */
- (void)generateBumper
{
	__block RBPMiniGameRollBumper *newBumper = nil;
	
	[self.bumpers enumerateObjectsUsingBlock:^(RBPMiniGameRollBumper *obj, NSUInteger idx, BOOL *stop) {
		if (!obj.parent && !obj.hasActions) {
			newBumper = obj;
			stop = (BOOL *)YES;
		}
	}];
	
	if (!newBumper) {
		
		newBumper = [[RBPMiniGameRollBumper alloc] init];
		newBumper.physicsBody.categoryBitMask = RBPCollisionCategoryBumper;
		
	}
	
	[newBumper setScale:0.0];
	
	if ([self randomlyPositionNode:newBumper attemptCount:0]) {
		
		[self.bumpers addObject:newBumper];
		[self randomlyRotateNode:newBumper];
		
		[newBumper runAction:[SKAction scaleTo:1.0 duration:0.25]];
		
		[newBumper startRotating];
		
	} else {
		
		[newBumper removeFromParent];
		
	}
}

/**
 *  y = 20/ln(x + 1)
 *		where x = difficulty
 *
 *  @param difficulty
 *
 *  @return CGFloat
 */
- (CGFloat)batteryDrainDurationForDifficulty:(NSUInteger)difficulty
{
	return 20.0 / log(self.difficultyLevel + 1.0);
}

/**
 *  y = (1 / 5)x + [1 / (x + 1)] + 4
 *		where x = difficulty
 *
 *  @param difficulty
 *
 *  @return NSUInteger
 */
- (NSUInteger)bumperCountForDifficulty:(NSUInteger)difficulty
{
	CGFloat y = (1.0 / 5.0) * difficulty;
	y += 1.0 / (difficulty + 1.0);
	
	return y + 4;
}

- (void)generateBumpersForDifficulty:(NSUInteger)difficulty minDelay:(CGFloat)minDelay maxDelay:(CGFloat)maxDelay
{
	if (self.generateBumperOperations.count > 0) {
		return;
	}
	
	 __unsafe_unretained RBPMiniGameScene_Roll *weakSelf = self;
	
	// remove current bumpers
	for (SKSpriteNode *bumper in self.bumpers) {
		[bumper runAction:[SKAction scaleTo:0.0 duration:0.25] completion:^{
			[bumper removeFromParent];
		}];
	}
	
	
	for (NSUInteger x = 0; x < [weakSelf bumperCountForDifficulty:weakSelf.difficultyLevel]; x++) {
		
		// Random delay within supplied range
		CGFloat randomDelay = ((CGFloat)arc4random() / 0x100000000 * (maxDelay - minDelay)) + minDelay;
		
		NSBlockOperation *operation = [[NSBlockOperation alloc] init];
		[self.generateBumperOperations addObject:operation];
		__unsafe_unretained NSOperation *weakOperation = operation;
		
		[operation addExecutionBlock:^{
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.25 + randomDelay * NSEC_PER_SEC)),
						   dispatch_get_main_queue(), ^{
							   
							   if (!weakOperation.cancelled) {
								   [weakSelf generateBumper];
								   [weakSelf.generateBumperOperations removeObject:weakOperation];
							   }
							   
						   });
			
		}];
		
		[[NSOperationQueue mainQueue] addOperation:operation];
		
	}
	
}

/**
 *  Attempt to randomly position a node such that no other node intersects it
 *
 *  @param node
 *  @param attemptCount
 *
 *  @return success
 */
- (BOOL)randomlyPositionNode:(SKSpriteNode *)node attemptCount:(NSInteger)attemptCount
{
	if (attemptCount > 100) {
		return NO;
	}
	
	if (!node.parent) {
		[self addChild:node];
	}
	
	// Random position within the scene bounds with x% padding on each side
	CGFloat xPosition = MAX(self.size.width * 0.15, arc4random_uniform(self.size.width * 0.85));
	CGFloat yPosition = MAX(self.size.height * 0.15, arc4random_uniform(self.size.height * 0.85));
	node.position = CGPointMake(xPosition, yPosition);
	
	
	// Check distance from player
	if ([self distanceFromNode:node toNode:self.player] < MAX(self.player.size.width, self.player.size.height) * 2.0) {
		return [self randomlyPositionNode:node attemptCount:attemptCount + 1];
	}
	
	// Check distance from bumpers
	for (SKSpriteNode *bumper in self.bumpers) {
		if (node != bumper && bumper.parent &&
			[self distanceFromNode:node toNode:bumper] < MAX(self.player.size.width, self.player.size.height) * 1.5) {
			return [self randomlyPositionNode:node attemptCount:attemptCount + 1];
		}
	}
	
	// Check distance from pickups
	for (SKSpriteNode *pickup in self.pickups) {
		if (node != pickup && pickup.parent &&
			[self distanceFromNode:node toNode:pickup] < MAX(self.player.size.width, self.player.size.height) * 1.5) {
			return [self randomlyPositionNode:node attemptCount:attemptCount + 1];
		}
	}
	
	return YES;
}

- (void)randomlyRotateNode:(SKSpriteNode *)node
{
	NSInteger deg = arc4random() % 360;
	CGFloat rad = deg * (M_PI / 180.0);
	node.zRotation = rad;
}

- (void)pulseNode:(SKNode *)node scale:(CGFloat)scale duration:(CGFloat)duration
{
	static NSString *pulseScaleKey = @"pulseScaleActionKey";
	
	if ([node actionForKey:pulseScaleKey]) {
		return;
	}
	
	// Disable contact while animating so more collisions dont happen
	uint32_t contanctBitMask = node.physicsBody.contactTestBitMask;
	node.physicsBody.contactTestBitMask = RBPCollisionCategoryNone;
	
	
	SKAction *action = [SKAction scaleTo:scale duration:duration * 0.5];
	SKAction *actionCompletion = [SKAction runBlock:^{
		[node runAction:[SKAction scaleTo:1.0 duration:duration * 0.5] withKey:pulseScaleKey];
		node.physicsBody.contactTestBitMask = contanctBitMask;
	}];
	
	[node runAction:[SKAction sequence:@[action, actionCompletion]] withKey:pulseScaleKey];
}

- (void)pulseNode:(SKNode *)node color:(UIColor *)color duration:(CGFloat)duration
{
	static NSString *pulseColorKey = @"pulseColorActionKey";
	
	if ([node actionForKey:pulseColorKey]) {
		return;
	}
	
	SKAction *action = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.5 duration:duration * 0.5];
	SKAction *actionCompletion = [SKAction runBlock:^{
		[node runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:duration * 0.5] withKey:pulseColorKey];
	}];
	
	[node runAction:[SKAction sequence:@[action, actionCompletion]] withKey:pulseColorKey];
}

#pragma mark - SKScene

- (void)update:(CFTimeInterval)currentTime
{
	[super update:currentTime];
	
	
	// *****************
	// Rotate player
	// *****************
	
	// Legs of triangle for rotation calculation
	CGFloat adjacent = self.player.position.x + self.player.physicsBody.velocity.dx;
	CGFloat opposite = self.player.position.y + self.player.physicsBody.velocity.dy;
	CGFloat currentAngle = self.player.zRotation + M_PI_2;
	
	// This will ensure the rotation node is always outside of the players radius, making the rotation smoother
	// when the velocity is ~0
	CGFloat playerHalfWidth = self.player.size.width * 0.5;
	CGFloat xMin = cos(currentAngle) * playerHalfWidth;
	CGFloat yMin = sin(currentAngle) * playerHalfWidth;
	
	adjacent += xMin;
	opposite += yMin;
	
	self.playerRotationNode.position = CGPointMake(adjacent, opposite);
	
	
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
    for (RBPMiniGameRollBattery *pickup in self.pickups) {
		if (pickup.parent && [self.children containsObject:pickup]) {
			
			if ([pickup intersectsNode:self.player]) {
				
				[RBPSoundManager runSoundAction:self.action_PickupSound onNode:self.player];
				self.score += pickup.chargePercentage;
				[pickup removeFromParent];
				
				
				// x second delay
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
							   dispatch_get_main_queue(), ^{
								   [self generatePickup];
							   });
				
			}
		
            
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
	SKPhysicsBody *playerBody = nil;
	SKPhysicsBody *otherBody = nil;
	
	if (contact.bodyA.node == self.player) {
		playerBody = contact.bodyA;
		otherBody = contact.bodyB;
	} else if (contact.bodyB.node == self.player) {
		playerBody = contact.bodyB;
		otherBody = contact.bodyA;
	}
	
	if (!playerBody) {
		return;
	}
	
	
	if (![self isPlayerVelocityToHigh]) {
		
		CGVector collisionImpluse = CGVectorMake(contact.contactNormal.dx * contact.collisionImpulse * 0.15,
												 contact.contactNormal.dy * contact.collisionImpulse * 0.15);
		[self.player.physicsBody applyImpulse:collisionImpluse atPoint:contact.contactPoint];
		
	}
	
	self.player.physicsBody.linearDamping = MAX(1.0, self.player.physicsBody.linearDamping) * 3.0;
	
	if (otherBody.categoryBitMask == RBPCollisionCategoryWall) {
		[RBPSoundManager runSoundAction:self.action_BumperCollisionSound onNode:self.player];
	} else if (otherBody.categoryBitMask == RBPCollisionCategoryBumper) {
		[self pulseNode:otherBody.node scale:1.3 duration:0.4];
		[RBPSoundManager runSoundAction:self.action_BumperCollisionSound onNode:self.player];
	}
	
	
	[self pulseNode:self.player color:[UIColor redColor] duration:0.35];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
}

#pragma mark - RBPMiniGameScene

- (NSString *)minigameName
{
	return @"Bumper Ball";
}

- (void)setScore:(CGFloat)score
{
	[super setScore:score];
	
	// self.difficultyLevel = (score / 3) + 1;
	self.difficultyLevel = (NSUInteger)score;
}

- (void)setDifficultyLevel:(NSUInteger)difficultyLevel
{
	NSUInteger temp = self.difficultyLevel;
	
	[super setDifficultyLevel:difficultyLevel];
	
	if (temp > 0 && temp < self.difficultyLevel) { // Difficulty did increase
		
		[self generateBumpersForDifficulty:self.difficultyLevel minDelay:0.5 maxDelay:1.25];
		
	}
}

#pragma mark - Internal

- (NSMutableArray *)pickups
{
    if (!_pickups) {
        _pickups = [[NSMutableArray alloc] init];
    }
    
    return _pickups;
}

- (NSMutableArray *)bumpers
{
	if (!_bumpers) {
		_bumpers = [[NSMutableArray alloc] init];
	}
	
	return _bumpers;
}

- (NSMutableArray *)generateBumperOperations
{
	if (!_generateBumperOperations) {
		_generateBumperOperations = [[NSMutableArray alloc] init];
	}
	
	return _generateBumperOperations;
}

@end




