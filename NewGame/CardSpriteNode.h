//
//  CardSpriteNode.h
//  NewGame
//
//  Created by Guest User on 7/21/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CardSpriteNode : SKSpriteNode {
    //id <CardSpriteNodeDelegate> delegate;
}

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) bool isRevealed;
@property (strong, nonatomic, readonly) NSNumber *uniqueID;
@property (strong, nonatomic, readonly) NSNumber *matchID;

-(id)initCardWithUniqueID:(NSNumber*)uniqueID MatchID:(NSNumber *)matchID backImageNamed:(NSString *)backImageName forSize:(CGSize)size;
-(void)revealCard;
-(void)hideCard;
-(void)flipCard;
-(void)removeCard;

@end

@protocol CardSpriteNodeDelegate

@optional
- (void)cardDidFinishFlipping:(CardSpriteNode *)card;

@end
