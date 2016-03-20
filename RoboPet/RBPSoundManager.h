//
//  RBPSoundManager.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import Foundation;
@import SpriteKit;





@interface RBPSoundManager : NSObject
{
}

+ (BOOL)soundEnabled;
+ (void)setSoundEnabled:(BOOL)soundEnabled;

/**
 *  Play a sound action on a node. Won't play if sound is disabled
 *
 *  @param action
 *  @param node
 */
+ (void)runSoundAction:(SKAction *)action onNode:(SKNode *)node;

@end




