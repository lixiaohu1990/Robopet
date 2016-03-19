//
//  RBPBaseScene.h
//  RoboPet
//
//  Created by Pat Sluth on 2016-03-05.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import SpriteKit;





@interface RBPBaseScene : SKScene
{
}

- (void)setBackgroundImageName:(NSString *)imageName;

- (void)initialize;
- (void)restart;

/**
 *  Calculate distance between nodes (Pythagoras Theorem)
 *
 *  @param node
 *  @param toNode
 *
 *  @return CGFloat
 */
- (CGFloat)distanceFromNode:(SKNode *)node toNode:(SKNode *)toNode;

@end




