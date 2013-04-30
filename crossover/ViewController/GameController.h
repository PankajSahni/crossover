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
#import "SettingsViewController.h"
#import "ShowWinnerViewController.h"
@interface GameController : UIViewController<GameModelDelegate,SettingsViewControllerDelegate,ShowWinnerViewControllerDelegate>{
    GameModel *gameModelObject;
    BoardUIView *boardModelObject;
    SettingsViewController *settingsViewControllerObject;
    UIButton *button_new_game;
    UIButton *button_help;
    UIButton *button_share;
    UIButton *button_vs_player;
    UIButton *button_vs_computer;
    UIButton *button_vs_gamecenter;
    UIButton *button_simple;
    UIButton *button_medium;
    UIButton *button_hard;
    UIButton *button_cancel;
    UIView *view_popover;
    UIActivityIndicatorView *spinner;
    CGRect cgrect_dragged_button;
    CGRect cgrect_drag_started;
    UIButton *coin;
    UIButton *button_resume;
    UIButton *button_yes;
    UIButton *button_no;
    int tag_coin_picked;
    NSTimer *timer;
    UILabel *time_label_P1;
    UILabel *time_label_P2;
    UILabel *debugLabel;
    id cgRectObject;
    UIImageView *imageview_captured;
    UILabel *label_player_one;
    UILabel *label_player_two;
    NSTimer *timer_label;
}
@end
