//
//  RBPMiniGameScene_Music.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-20.
//  Copyright (c) 2016 Pat Sluth. All rights reserved.
//

#import "RBPMiniGameScene_Music.h"



@interface RBPMiniGameScene_Music()
{
    NSMutableArray* singImages;
    SKTexture* bulbTexture;
    SKTexture* bulbOnTexture;
}

@end



@implementation RBPMiniGameScene_Music

#pragma mark - SKScene

// Entered scene
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    // Setup view here
    CGSize sceneSize = self.scene.size;
    
    // Click Zone Setup
    int nElements = 5;
    float s_size = sceneSize.width / ( nElements + 1 );
    float s_spacing = s_size * 0.1;
    
    // Calculate sprite measurements
    CGSize spriteSize = CGSizeMake( s_size, s_size );
    float totalWidth = ( spriteSize.width + s_spacing ) * nElements;
    float centerXPos = ( sceneSize.width - totalWidth ) / 2.0;
    float centerYPos = ( sceneSize.height - spriteSize.height ) / 2.0;
    
    // Create colors
    NSArray* colors = [ self createColorList: nElements ];
    
    // Load Graphics
    bulbTexture = [SKTexture textureWithImageNamed: @"bulb"];
    bulbOnTexture = [SKTexture textureWithImageNamed: @"bulb"];
    
    // Create and position sprites
    singImages = [[NSMutableArray alloc] initWithCapacity: nElements];
    for( int i = 0; i < nElements; i++ )
    {
        // Get sprite from array
        SKSpriteNode* sprite = [SKSpriteNode new];
        sprite.texture = bulbTexture;
        sprite.size = spriteSize;
        sprite.color = colors[i];
        sprite.colorBlendFactor = 1.0;
        
        singImages[i] = sprite; // Append to sprite list
        
        // Position sprite at relevant location
        float x = i * ( spriteSize.width + s_spacing ) + spriteSize.width/2;
        sprite.position = CGPointMake( centerXPos + x, centerYPos + spriteSize.height/2);
        sprite.name = [NSString stringWithFormat: @"Sprite %i", i];
        
        // Add sprite to scene
        [self addChild:sprite];
    }
    
    SKLabelNode *label = [SKLabelNode labelNodeWithText:@"Music Mini Game"];
    label.position = CGPointMake(self.size.width / 2, self.size.height / 4);
    [self addChild:label];
}

// Creates a rainbow spread of n colors
-(NSArray*) createColorList: (int) nColor
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
-(void) onTouchSprite: (int) nth
{
    
}

// Respond to touch input on out scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check if on sprite
    for ( int i = 0; i < [singImages count]; i++ )
    {
        // If node touched is one of our sprites
        if ( node == [singImages objectAtIndex: i] )
        {
            [ self onTouchSprite: i ];
        }
    }
}

-(void) update: (CFTimeInterval) currentTime
{
    // ?
}

@end




