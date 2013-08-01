//
//  MyScene.m
//  NewGame
//
//  Created by Guest User on 7/21/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "StovetopScene.h"
//#import "CardSpriteNode.h"

@interface StovetopScene()

@property (strong, nonatomic) CardSpriteNode *firstCookieSelected;
@property (strong, nonatomic) CardSpriteNode *secondCookieSelected;
@property (assign, nonatomic) int numCookiesWide;
@property (assign, nonatomic) int numCookiesHigh;
@property (assign, nonatomic) float xOffset;
@property (assign, nonatomic) float yOffset;
@property (assign, nonatomic) CGSize cookieSize;

@end

@implementation StovetopScene

- (void)test:(int)value {
    NSLog(@"Test, Test.");
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSLog(@"frame = (%f, %f) - %f X %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        self.backgroundColor = [SKColor colorWithRed:104.0f/256.0f green:109.0f/256.0f blue:110.0f/256.0f alpha:1.0];
        
        // Initialize Variables.
        self.firstCookieSelected = nil;
        self.secondCookieSelected = nil;
        self.numCookiesWide = 4;
        self.numCookiesHigh = 5;
        
        self.xOffset = 10.0f; // This is a little convulted, but it makes sure all cookies are on screen and centered.
        float widthHeight = (self.frame.size.width - (self.xOffset*2))/self.numCookiesWide;
        self.cookieSize = CGSizeMake(widthHeight, widthHeight);
        self.yOffset = 0.0f + (self.frame.size.height - (self.cookieSize.height * self.numCookiesHigh))/2;
        
        // Build stuff up.
        [self createGameboard];
        
        self.enabled = YES;
    }
    return self;
}

//This sets the cards in a random order on the grid.
- (void)createGameboard {
    
    //Create an array of IDs.  This fixes the infinitely choosing unvailable IDs problem.
    NSMutableArray *cardIDs = [[NSMutableArray alloc] init];
    for (int count = 0; count < (self.numCookiesWide * self.numCookiesHigh)/2; count++) {
        [cardIDs addObject:[NSNumber numberWithInt:count]];
        [cardIDs addObject:[NSNumber numberWithInt:count]];
    }
    
    //This can start anywhere, but zero's nice.
    NSNumber *uniqueID = [NSNumber numberWithInt:0];
    
    //Move through the grid and place a card at each slot.
    for (int x = 0; x < self.numCookiesWide; x++) {
        for (int y = 0; y < self.numCookiesHigh; y++) {
            
            //Pick a random ID from the array, and remove it.
            int idIndex = arc4random() % [cardIDs count];
            NSNumber *matchID = [cardIDs objectAtIndex:idIndex];
            [cardIDs removeObjectAtIndex:idIndex];
            
            //Create the card and set its properties.
            CardSpriteNode *card = [[CardSpriteNode alloc] initCardWithUniqueID:uniqueID  MatchID:matchID backImageNamed:@"card-back" forSize:self.cookieSize];
            CGPoint position = CGPointMake((x*card.size.width) + self.xOffset + (card.size.width/2), (y*card.size.height) + self.yOffset + (card.size.height/2));
            card.position = position;
            card.delegate = self;
            [self addChild:card];
            
            //Don't forget to get a new uniqueID.
            uniqueID = [NSNumber numberWithInt:[uniqueID intValue] + 1];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (self.enabled) {
        for (UITouch *touch in touches) {
            //Get the touch location.
            CGPoint touchLocation = [touch locationInNode:self];
            
            //Find all the nodes under the touch.
            NSArray *nodes = [self nodesAtPoint:touchLocation];
            
            if ([nodes count]) {
                //If there are nodes, do something.
                for (SKNode *node in nodes) {
                    //Make sure it's the proper type.
                    if ([node isKindOfClass:[CardSpriteNode class]]) {
                        //Convert it and do your stuff.
                        CardSpriteNode *cardNode = (CardSpriteNode *)node;
                        
                        //If it's already revealed, then don't worry about it.
                        if (!cardNode.isRevealed) {
                            [cardNode revealCard];
                            //Check if this is the first or second card we've selected.
                            if (self.firstCookieSelected) {
                                //If we've already selected one, make sure we're not reselecting it.
                                if (cardNode.uniqueID != self.firstCookieSelected.uniqueID) {
                                    //If it's the second, save it for later.
                                    self.secondCookieSelected = cardNode;
                                    
                                    //***  We check for a match when the flip animation  ***//
                                    //***  finishes, in 'cardDidFinishFlipping'.         ***//
                                }
                                else {
                                    NSLog(@"Error: This card is already selected.");
                                }
                            }
                            //If it's the first, make sure to save it for later.
                            else {
                                self.firstCookieSelected = cardNode;
                            }
                        }
                    }
                }
            }
            else {
                //No nodes exist here.
            }
        }
    }
}

#pragma mark - Cards

//Exactly what it says on the tin.
- (BOOL)checkForAMatch {
    if (self.firstCookieSelected.matchID == self.secondCookieSelected.matchID) {
        NSLog(@"Match Found.");
        return YES;
    }
    else {
        NSLog(@"Sorry, No Match.");
        return NO;
    }
}

//Get rid of both cards.
- (void)removeSelectedCards {
    [self.firstCookieSelected removeCard];
    self.firstCookieSelected = nil;
    [self.secondCookieSelected removeCard];
    self.secondCookieSelected = nil;
}

//Set both cards back to hidden.
- (void)resetSelectedCards {
    [self.firstCookieSelected hideCard];
    self.firstCookieSelected = nil;
    [self.secondCookieSelected hideCard];
    self.secondCookieSelected = nil;
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - CardSpriteNodeDelegate

- (void)cardDidFinishFlipping:(CardSpriteNode *)card {
    //Make sure we have both cards selected.
    if (self.firstCookieSelected && self.secondCookieSelected && [card isEqual:self.secondCookieSelected]) {
        //If so, check for a match and react accordingly.
        if ([self checkForAMatch]) {
            [self removeSelectedCards];
        }
        else {
            [self resetSelectedCards];
        }
    }
}

@end
