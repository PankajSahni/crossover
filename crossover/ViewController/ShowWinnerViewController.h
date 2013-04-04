//
//  ShowWinnerViewController.h
//  crossover
//
//  Created by Shenu Gupta on 31/03/13.
//  Copyright (c) 2013 shenu.gupta2009@gmail.com. All rights reserved.
//

#import "GameController.h"
#import "GameModel.h"
@interface ShowWinnerViewController : GameController{
    GameModel *gameModelObject1;
}
@property (nonatomic, assign) int winner;
@end
