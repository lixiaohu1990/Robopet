//
//  RBPBaseSceneViewController.m
//  RoboPet
//
//  Created by Pat Sluth on 2016-01-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "RBPBaseSceneViewController.h"

#import "RBPBaseScene.h"





@interface RBPBaseSceneViewController ()
{
}

@end





@implementation RBPBaseSceneViewController

@dynamic view;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize sceneSize = CGSizeMake(self.view.bounds.size.width * [UIScreen mainScreen].scale,
                                  self.view.bounds.size.height * [UIScreen mainScreen].scale);
	
	
	Class sceneClass = [self sceneClass];
	NSAssert(sceneClass, @"sceneClass cannot be nil");
	NSAssert([sceneClass isSubclassOfClass:[RBPBaseScene class]],
			 ([NSString stringWithFormat:@"%@ must be subclass of %@", sceneClass, [RBPBaseScene class]]));
    RBPBaseScene *scene = [sceneClass sceneWithSize:sceneSize];
    scene.scaleMode = SKSceneScaleModeFill;
	
	
	NSAssert([self backgroundImageName], @"backgroundImageName cannot be nil");
	[scene setBackgroundImageName:[self backgroundImageName]];
	
	
    [self.view presentScene:scene];
    
#ifdef DEBUG
    self.view.showsFPS = YES;
    self.view.showsDrawCount = YES;
    self.view.showsNodeCount = YES;
    self.view.showsQuadCount = YES;
    self.view.showsPhysics = YES;
    self.view.showsFields = YES;
#endif
}

- (Class)sceneClass;
{
    return [SKScene class];
}

- (NSString *)backgroundImageName
{
	return nil;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




