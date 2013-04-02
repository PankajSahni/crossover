//
//  ViewController.h
//  crossover
//
//  Created by Mac on 27/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingleton.h"
#import "GameModel.h"
#import "BoardUIView.h"
#import "GCHelper.h"
@interface ViewController : UIViewController<GCHelperDelegate>{
    GameModel *gameModelObject;
    BoardUIView *boardModelObject;
    UIButton *button_new_game;
    UIButton *button_help;
    UIButton *button_share;
    UIButton *button_vs_player;
    UIButton *button_vs_computer;
    UIButton *button_vs_gamecenter;
    UIView *view_popover;
    UIActivityIndicatorView *spinner;
    CGRect cgrect_dragged_button;
    CGRect cgrect_drag_started;
    UIButton *coin;
    int tag_coin_picked;
    NSTimer *timer;
    UILabel *time_label_P1;
    UILabel *time_label_P2;
    
    
    
    
}
-(void) getPopOver;

-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;
@end
