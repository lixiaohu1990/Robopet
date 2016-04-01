//
//  RBPMiniGameScene_Music.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameScene_Music.h"

typedef NS_ENUM(NSInteger, GameStateType){
    StartCountDown,
    SimonTurn,
    SimonTransition,
    PlayerTurn,
    PlayerTransition,
    GameOverTransition,
    GameOver
};

@interface RBPMiniGameScene_Music()
{
    // Game Graphics Data
    NSMutableArray* SimonSprites;
    SKTexture* TexBulbOff;
    SKTexture* TexBulbOn;
    
    // Game Feedback
    SKLabelNode* UserPromptLabel;
    
    // Used by checkTime to check for elapsed time
    CFTimeInterval LastTick; // For checkTime
    CFTimeInterval LastTime; // Used to remember
    
    // Game Paramters
    NSInteger NumberOfSprites;          // Number of bulbs
    NSInteger SimonSequenceLength;      // Total length of sequence
    
    // Game Data
    NSMutableArray* SimonSaysSequence;  // Memory sequence
    NSInteger SimonSequencePosition;    // Position along sequence
    
    // Game State
    enum GameStateType GameState;   // Game State Enum
    NSInteger SimonSaysDepth;       // Depth into sequence
    NSInteger PlaybackStep;         // Used into animating / stepping through each state
}

// Preloaded assets

@property (strong, nonatomic) SKAction *action_SoundD;
@property (strong, nonatomic) SKAction *action_SoundF;
@property (strong, nonatomic) SKAction *action_SoundA;
@property (strong, nonatomic) SKAction *action_SoundC;
@property (strong, nonatomic) SKAction *action_SoundE;

@end



@implementation RBPMiniGameScene_Music

+ (instancetype) sceneWithSize: (CGSize) size
{
    RBPMiniGameScene_Music *scene = [super sceneWithSize:size];
    
    if (scene) { // Preload assets
        
        scene.action_SoundD = [SKAction playSoundFileNamed:@"music_d_note" waitForCompletion:NO];
        scene.action_SoundF = [SKAction playSoundFileNamed:@"music_f_note" waitForCompletion:NO];
        scene.action_SoundA = [SKAction playSoundFileNamed:@"music_a_note" waitForCompletion:NO];
        scene.action_SoundC = [SKAction playSoundFileNamed:@"music_c_note" waitForCompletion:NO];
        scene.action_SoundE = [SKAction playSoundFileNamed:@"music_e_note" waitForCompletion:NO];
        
    }
    
    return scene;
}

#pragma mark - Init

- (void)initialize
{
    [super initialize];

    // Setup view here
    CGSize sceneSize = self.scene.size;
    
    // Click Zone Setup
    NumberOfSprites = 5;
    SimonSequenceLength = NumberOfSprites * 40;
    float s_size = sceneSize.width / ( NumberOfSprites + 2 );
    float s_spacing = s_size * 0.1;
    
    // Calculate sprite measurements
    CGSize spriteSize = CGSizeMake( s_size, s_size );
    float totalWidth = ( spriteSize.width + s_spacing ) * NumberOfSprites;
    float centerXPos = ( sceneSize.width - totalWidth ) / 2.0;
    float centerYPos = ( sceneSize.height - spriteSize.height ) / 2.0;
    
    // Create colors
    NSArray* colors = [ self createColorList: NumberOfSprites ];
    
    // Load Graphics
    TexBulbOff = [SKTexture textureWithImageNamed: @"bulb"];
    TexBulbOn = [SKTexture textureWithImageNamed: @"bulb-on"];
    
    // Create and position sprites
    SimonSprites = [[NSMutableArray alloc] initWithCapacity: NumberOfSprites];
    for( int i = 0; i < NumberOfSprites; i++ )
    {
        // Get sprite from array
        SKSpriteNode* sprite = [SKSpriteNode new];
        sprite.texture = TexBulbOff;
        sprite.size = spriteSize;
        sprite.color = colors[i];
        sprite.colorBlendFactor = 1.0;
        
        SimonSprites[i] = sprite; // Append to sprite list
        
        // Position sprite at relevant location
        float x = i * ( spriteSize.width + s_spacing ) + spriteSize.width/2;
        sprite.position = CGPointMake( centerXPos + x, centerYPos + spriteSize.height/2);
        sprite.name = [NSString stringWithFormat: @"Sprite %i", i];
        
        // Add sprite to scene
        [self addChild: sprite];
    }
    
    // Create the simon says randomized sequence
    SimonSaysSequence = [[NSMutableArray alloc] initWithCapacity: SimonSequenceLength ];
    [self addRandomToSequence]; // Add first light to remember
    
    // User Prompt
	UserPromptLabel = [SKLabelNode new];
	UserPromptLabel.fontColor = [UIColor blackColor];
    UserPromptLabel.fontSize = self.size.height * 0.08;
    UserPromptLabel.position = CGPointMake(self.size.width / 2, self.size.height - self.size.height / 4 - UserPromptLabel.fontSize / 2 );
    [self addChild: UserPromptLabel];
    
    // Start with a memory of 1
    SimonSaysDepth = 1;
    GameState = StartCountDown;
    [self updateLabels];
}

- (void)restart
{
	[super restart];
}

#pragma mark - SKScene

-(void) addRandomToSequence
{
    [SimonSaysSequence addObject: [self randomNumber: 0 to: NumberOfSprites ]];
}

// Respond to touch input on our scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Touch information
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Sprite-kit node
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if on sprite
    for ( int i = 0; i < [SimonSprites count]; i++ )
    {
        // If node touched is one of our sprites
        if ( node == [SimonSprites objectAtIndex: i] )
        {
            [ self onTouchSprite: i ];
        }
    }
}

// Produces a random nubmer in a range and returns a NSNumber instance of it
-(NSNumber*) randomNumber:(NSInteger) a
                       to:(NSInteger) b
{
    int n = (int) a + ( arc4random() % ( b - a ));
    return [NSNumber numberWithInteger: n];
}

// Creates a rainbow spread of n colors
-(NSArray*) createColorList: (NSInteger) nColor
{
    NSMutableArray* colors = [NSMutableArray arrayWithCapacity: nColor];
    for( int i = 0; i < nColor; i++ )
    {
        float hue = i/(float)nColor;
        SKColor* color = [SKColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
        [colors addObject: color ];
    }
    
    return colors;
}

// Respond to touch input on our sprites
-(void) onTouchSprite: (NSInteger) nth
{
    if( GameState == PlayerTurn && PlaybackStep == 0 )
    {
        // If less than depth, move to next guess
        if( SimonSequencePosition < SimonSaysDepth )
        {
            NSInteger expectedIndex = [self getBulbIndex: SimonSequencePosition];
            
            PlaybackStep = 1;
            LastTick = LastTime; // Measure elasped time from 'now'
            
            // Turn on bulb touched
            [self changeBulb: nth on: true];
            [self playTone: nth completion:^{
                
                // Didn't touch exepcted
                if( nth != expectedIndex )
                {
                    // Woah, wrong one!
                    // GAME OVER!
                    [self.minigameDelegate onMiniGameGameOver:self];
                }
                // Touched expected
                else
                {
                    // Yay, good job!
                }
                
            }];
            
            
        }
    }
}

-(void) playTone: (NSInteger) nth completion:(void (^)())block;
{
    SKAction *soundAction = nil;
    
    // Play tone
    switch (nth) {
        case 0:
            // Play D Tone
            soundAction = self.action_SoundD;
            break;
        case 1:
            // Play F Tone
            soundAction = self.action_SoundF;
            break;
        case 2:
            // Play A Tone
            soundAction = self.action_SoundA;
            break;
        case 3:
            // Play C Tone
            soundAction = self.action_SoundC;
            break;
        case 4:
            // Play E Tone
            soundAction = self.action_SoundE;
            break;
    }
    
    if (soundAction) {
        if ([RBPSoundManager soundEnabled]) {
            [UserPromptLabel runAction:soundAction completion:block];
        }
    }
}

-(void) update: (CFTimeInterval) currentTime
{
	[super update:currentTime];
	
    if( LastTick == 0 ) LastTick = currentTime;
    LastTime = currentTime;
    
    switch(GameState)
    {
        default: break; // Covers unimplemented states.
        
        case StartCountDown:
            [self doStartCountDownStateUpdate];
            break;
            
        case PlayerTurn:
            [self doPlayerTurnStateUpdate];
            break;
            
        case SimonTransition:
            [self doSimonTransitionStateUpdate];
            break;
            
        case PlayerTransition:
            [self doPlayerTransitionStateUpdate];
            break;
            
        case SimonTurn:
            [self doSimonTurnStateUpdate];
            break;
    }
}

// Startup time, when first entering the scene
-(void) doStartCountDownStateUpdate
{
    if( [self checkTime: 0.1] )
    {
        [self changeGameState: SimonTransition];
    }
}

// Transition to SimonTurn
-(void) doSimonTransitionStateUpdate
{
    if( [self checkTime: 2.0] )
    {
        [self changeGameState: SimonTurn];
    }
}

// Transition to PlayerTurn
-(void) doPlayerTransitionStateUpdate
{
    if( [self checkTime: 0.1] )
    {
        [self changeGameState: PlayerTurn];
    }
}

// Do PlayerTurn logic
-(void) doPlayerTurnStateUpdate
{
    // If step is 1 during player turn, it is to turn off the bulb
    if( PlaybackStep == 1 )
    {
        if([self checkTime: 0.33])
        {
            [self changeBulb: [self getBulbIndex: SimonSequencePosition] on: false];
            SimonSequencePosition++;
            [self updateLabels];
            PlaybackStep = 0;
        }
        
        // Change state to simon playback and make one longer.
        if( SimonSequencePosition >= SimonSaysDepth )
        {
            // Increase chain size and increment level
            SimonSaysDepth++;
            self.difficultyLevel++;
            
            // Add score
            self.score += ceil( pow( 1.075, SimonSequencePosition ) / 1.315 );
            
            // Add next light to sequence
            [self addRandomToSequence];
            
            // Go to simon transition state
            [self changeGameState: SimonTransition];
        }
    }
}

// Do SimonTurn logic
-(void) doSimonTurnStateUpdate
{
    // Simon Says Playback
    if( [self checkTime: 0.33] )
    {
        // If there are more frames to see.
        if( SimonSequencePosition < SimonSaysDepth )
        {
            // Do correct action for simon
            switch( PlaybackStep )
            {
                case 0:
                    [self changeBulb: [self getBulbIndex: SimonSequencePosition] on: true ];
                    [self playTone: [self getBulbIndex: SimonSequencePosition] completion:nil];
                    PlaybackStep = 1;
                    break;
                    
                case 1:
                    [self changeBulb: [self getBulbIndex: SimonSequencePosition] on: false ];
                    SimonSequencePosition++;
                    PlaybackStep = 0;
                    break;
            }
            
            // Move to next element
            [self updateLabels];
        }
        else
        {
            [self changeGameState: PlayerTransition];
        }
    }
}

-(BOOL) checkTime: (float) x
{
    if( ( LastTime - LastTick) > x )
    {
        LastTick = LastTime;
        return true;
    }
    
    return false;
}

-(void) changeGameState: (GameStateType) state
{
    GameState = state;
    SimonSequencePosition = 0;
    PlaybackStep = 0;
    
    [self updateLabels];
    
    // Disable all the bulbs
    for( int i = 0; i < NumberOfSprites; i++ )
        [self changeBulb: i on: false];
}

-(void) updateLabels
{
    switch( GameState )
    {
        case StartCountDown:
            UserPromptLabel.text = @"Welcome!";
            break;
        
        case SimonTurn:
            UserPromptLabel.text = @"Watch and Remember!";
            break;
        
        case SimonTransition:
            UserPromptLabel.text = @"Get Ready To Remember";
            break;
            
        case PlayerTurn:
            UserPromptLabel.text = @"Your Turn!";
            break;
            
        case PlayerTransition:
			UserPromptLabel.text = @"...";
			break;
			
		case GameOverTransition:
			UserPromptLabel.text = @"Ouch!";
			break;
			
		case GameOver:
			UserPromptLabel.text = @"Game Over!";
			break;
			
		default:
			UserPromptLabel.text = @"...";
			break;
    }
}

-(NSInteger) getBulbIndex: (NSInteger) seqIndex
{
    return [SimonSaysSequence[seqIndex] integerValue];
}

-(void) changeBulb: (NSInteger) index on:(BOOL) enable
{
    // Update scene
    SKSpriteNode* sprite = SimonSprites[index];
    sprite.texture = enable ? TexBulbOn : TexBulbOff;
}

- (NSString *)gameOverMessage
{
    if (self.score > 0.0 && self.score >= self.highScore) {
        return [NSString stringWithFormat:@"NEW HIGH SCORE!!!\n\n%.1f", self.score];
    }
    
    return [NSString stringWithFormat:@"Score:%.1f\nHigh Score:%.1f", self.score, self.highScore];
}

@end




