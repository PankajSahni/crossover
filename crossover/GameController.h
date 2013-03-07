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
}
@property (nonatomic, retain) UIImageView *imageview_main_background;
@property (nonatomic, retain) UIView *view_popover;
@property (nonatomic, retain) UIImageView *imageview_new_game;
@property (nonatomic, retain) UIImageView *imageview_help;
@property (nonatomic, retain) UIImageView *imageview_share;
-(void) getPopOver;
-(UIView *) getDarkBackground:(CGRect)cgrect;

-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;
@end
