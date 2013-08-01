//
//  CardSpriteNode.m
//  NewGame
//
//  Created by Guest User on 7/21/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "CardSpriteNode.h"
#import "AppDelegate.h"

@interface CardSpriteNode()

@property (assign, nonatomic) bool shouldFlip;
@property (assign, nonatomic) bool didFlip;
@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UIImage *frontImage;
@property (strong, nonatomic) SKTexture *backTexture;
@property (strong, nonatomic) SKTexture *frontTexture;
@property (strong, nonatomic, readwrite) NSNumber *uniqueID;
@property (strong, nonatomic, readwrite) NSNumber *matchID;


@end

@implementation CardSpriteNode

///////testing

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

///end

- (id)initCardWithUniqueID:(NSNumber *)uniqueID MatchID:(NSNumber *)matchID backImageNamed:(NSString *)backImageName forSize:(CGSize)size {
    self.uniqueID = uniqueID;
    self.matchID = matchID;
    self.isRevealed = NO;
    
    //The back texture is simple.
    self.backImage = [UIImage imageNamed:backImageName];
    self.backTexture = [SKTexture textureWithImage:self.backImage];
    
    //The front, not so much.
    NSArray *cardImagesArray = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cardTextures];
    //UIImage *frontImage;
    if ([cardImagesArray count] > [matchID intValue]) {
        self.frontImage = [cardImagesArray objectAtIndex:[matchID intValue]];
    } else {
        NSLog(@"Warning: There isn't a card texture at this index (%@).  Applying the default texture instead.", self.matchID);
        self.frontImage = [UIImage imageNamed:@"card-notexture"];
    }
    self.frontTexture = [SKTexture textureWithImage:self.frontImage];
    
    
    return [super initWithTexture:self.backTexture color:nil size:size];
}

// Always sets the card to show it's front texture.
- (void)revealCard {
    NSLog(@"Reveal card with ID: %@", self.uniqueID);
    self.isRevealed = YES;
    [self animateToShowTexture:self.frontTexture];
}

// Always sets the card to show it's back texture.
- (void)hideCard {
    NSLog(@"Hide card with ID: %@", self.uniqueID);
    self.isRevealed = NO;
    [self animateToShowTexture:self.backTexture];
}

// Alternates the card between it's front and back textures.
- (void)flipCard {
    if (self.isRevealed) {
        [self hideCard];
    }
    else {
        [self revealCard];
    }
}

// Main logic for the flip animation.
- (void)animateToShowTexture:(SKTexture *)texture {
    float flipDuration = 0.25f;
    
    SKAction *turnUp = [SKAction scaleXTo:0.0 duration:flipDuration];
    SKAction *switchTexture = [SKAction setTexture:texture];
    SKAction *turnDown = [SKAction scaleXTo:1.0 duration:flipDuration];
    SKAction *flipAction = [SKAction sequence:[NSArray arrayWithObjects:turnUp, switchTexture, turnDown, nil]];
    [self runAction:flipAction completion:^{
        if ([self.delegate respondsToSelector:@selector(cardDidFinishFlipping:)]) {
            [self.delegate cardDidFinishFlipping:self];
        }
    }];
}

// Any cleanup or outro code goes here.
- (void)removeCard {
    NSLog(@"Remove card with uniqueID: %@", self.uniqueID);
    float fadeDuration = 0.3f;
    SKAction *scaleDown = [SKAction scaleTo:0.6f duration:fadeDuration];
    SKAction *fade = [SKAction fadeAlphaTo:0.0f duration:fadeDuration];
    SKAction *fadeOut = [SKAction group:[NSArray arrayWithObjects:scaleDown, fade, nil]];
    [self runAction:fadeOut completion:^{
        [self removeFromParent];
    }];
}

@end
