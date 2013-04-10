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

typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    __unsafe_unretained NSArray *player_positions;
} MessageMove;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

@interface GameController : UIViewController<GCHelperDelegate>{
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
    
    UILabel *debugLabel;
    GameState gameState;
    BOOL isPlayer1;
    uint32_t ourRandom;
    BOOL receivedRandom;
    NSString *otherPlayerID;
    
    
    
    
}
-(void) getPopOver;

-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;
@end
