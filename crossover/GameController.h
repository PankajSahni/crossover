//
//  ViewController.h
//  crossover
//
//  Created by Mac on 27/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingleton.h"
#import "GlobalUtility.h"
#import "GameModel.h"
@interface ViewController : UIViewController{
    GlobalUtility *globalUtilityObject;
    GameModel *gameModelObject;
    UIButton *button_new_game;
    UIButton *button_help;
    UIButton *button_share;
    UIButton *button_vs_player;
    UIButton *button_vs_computer;
    UIButton *button_vs_gamecenter;
    UIView *view_popover;
}
-(void) getPopOver;
//-(UIView *) getDarkBackground:(CGRect)cgrect;

-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;
@end
