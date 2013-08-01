//
//  MyScene.h
//  NewGame
//

//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CardSpriteNode.h"

@interface StovetopScene : SKScene <CardSpriteNodeDelegate>

@property (assign, nonatomic) bool enabled;

-(void)test:(int)value;

@end
