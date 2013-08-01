//
//  CardMatchViewController.h
//  NewGame
//
//  Created by Josh on 7/30/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface CardMatchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *stovetopView;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UILabel *clockDarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockActiveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stoveKnobImageView;

@end
