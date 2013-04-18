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
}

@end
