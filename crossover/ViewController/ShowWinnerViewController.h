//
//  ShowWinnerViewController.h
//  crossover
//
//  Created by Shenu Gupta on 31/03/13.
//  Copyright (c) 2013 shenu.gupta2009@gmail.com. All rights reserved.
//


#import "GameModel.h"
@protocol ShowWinnerViewControllerDelegate<NSObject>
- (void)new_game;
@end
@interface ShowWinnerViewController : UIViewController{
    GameModel *gameModelObject;
    id <ShowWinnerViewControllerDelegate> delegate_ShowWinnerViewController;
    UIView *view_popover;
}
@property (nonatomic, assign) int winner;
@property (retain) id <ShowWinnerViewControllerDelegate> delegate_ShowWinnerViewController;
@end
