//
//  CardMatchViewController.m
//  NewGame
//
//  Created by Josh on 7/30/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "CardMatchViewController.h"
#import "StovetopScene.h"

typedef NS_ENUM(int, gameDifficultyLevel) {
    gameDifficultyLevelUndefined,
    gameDifficultyLevelEasy,
    gameDifficultyLevelMedium,
    gameDifficultyLevelHard,
};


@interface CardMatchViewController ()

@property (strong, nonatomic) StovetopScene *stovetopScene;
@property (assign, nonatomic) int difficulty;
@property (assign, nonatomic) int maxSeconds;
@property (assign, nonatomic) int currentSeconds;

@end

@implementation CardMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    //SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    SKView *stovetopSKView = (SKView *)self.stovetopView;
    stovetopSKView.showsFPS = YES;

    // Set the difficulty.
    [self setDifficultyLevel:gameDifficultyLevelHard];
    
    // Set and start the timer.  //<<< The font isn't working! >_<
    //[self.clockActiveLabel setFont:[UIFont fontWithName:@"LetsgoDigital-Regular" size:37.0f]];
    self.clockActiveLabel.font = [UIFont fontWithName:@"Evanescent" size:37.0f];
    [self beginTimer:self.clockActiveLabel withNumberOfSeconds:[NSNumber numberWithInt:self.maxSeconds]];
    
    // Create and configure the scene.
    self.stovetopScene = [StovetopScene sceneWithSize:self.stovetopView.bounds.size];
    self.stovetopScene.scaleMode = SKSceneScaleModeFill;
    
    // Present the scene.
    [stovetopSKView presentScene:self.stovetopScene];
}

#pragma mark - Setup

// This initializes all the values that are based on difficulty.
- (void)setDifficultyLevel:(int)difficulty {
    self.difficulty = difficulty;
    
    // Turn the knob.
    float radiansBetweenDifficulties = 0.785398163; // 45 degrees. (pi / (#difficulties + 1))
    self.stoveKnobImageView.transform = CGAffineTransformMakeRotation(radiansBetweenDifficulties * self.difficulty);
    
    // Set any values unique to each difficulty.
    switch (difficulty) {
        case gameDifficultyLevelEasy:
            self.maxSeconds = 240;
            break;
            
        case gameDifficultyLevelMedium:
            self.maxSeconds = 120;
            break;
            
        case gameDifficultyLevelHard:
            self.maxSeconds = 45;
            break;
            
        default:
            break;
    }
}

#pragma mark - Timer Methods

// Initializes all the timer info, and gets the countdown started.
- (void)beginTimer:(UILabel *)timerLabel withNumberOfSeconds:(NSNumber *)totalSeconds {
    self.currentSeconds = [totalSeconds intValue];
    [self updateTimer:nil];
    NSDictionary *timerInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:timerLabel, @"activeLabel", totalSeconds, @"totalSeconds", nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:timerInfoDict repeats:YES];
}

// Prints the countdown to a label. //<<< How do I pass in the label to be updated, without creating a new instance every time?
- (void)updateTimer:(NSTimer *)timer {
    if (self.currentSeconds >= 0) {
        int minutes = self.currentSeconds/60;
        int seconds = self.currentSeconds%60;
        [self.clockActiveLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
        
        if (timer) {
            self.currentSeconds -= timer.timeInterval;
        }
    }
    else {
        NSLog(@"Time ran out.");
        
        self.stovetopScene.enabled = NO; //<<< How do I access these variables?
        //[self.stovetopScene test:5];     //<<<
        
        
        //TODO: Figure out how to stop the timer from repeating forever.
        //NOTE: using 'invalidate' and setting it to nil had no visible effect.
    }
}

#pragma mark - UIView

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
