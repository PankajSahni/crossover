//
//  SettingsViewController.h
//  crossover
//
//  Created by Pankaj on 18/04/13.
//
//

#import <UIKit/UIKit.h>
#import "SettingsBackgroundUIView.h"
#import "GameModel.h"
@interface SettingsViewController : UIViewController{
    SettingsBackgroundUIView *settingsBackgroundUIViewObject;
    GameModel *gameModelObject;
    id cgRectObject;
    UIButton *coin;
    UILabel *label_player_one;
    UILabel *label_player_two;
    UIButton *player_one_coin;
    UIButton *player_two_coin;
    int active_player;
    UIButton *imageview_sound;
    UIButton *button_offbutton_case_on;
    UIButton *button_onbutton_case_off;
    UIButton *button_onbutton_case_on;
    UIButton *button_offbutton_case_off;

}

@end
