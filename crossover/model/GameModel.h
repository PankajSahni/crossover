//
//  GameModel.h
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AiEngine.h"
#import "GCHelper.h"
#import "MyEnums.h"
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
    int newposition;
    int captured;
    int move;
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

@protocol GameModelDelegate
- (void)changeMyTurnLabelMessage:(BOOL)status;
- (void)initialSetUpMessagesForLabel:(NSString *)string;
-(void)addLabelToShowMultiplayerGameStatus;
-(void)animateComputerOrGameCenterMove:(NSDictionary *)opposition_turn;
-(void)getBoard;
-(void)showWinner:(int)winner;
@end

@interface GameModel : NSObject<GCHelperDelegate>{
    AiEngine *aiEngineObject;
    id <GameModelDelegate> delegate_game_model;
    GameState gameState;
    NSString *otherPlayerID;
    BOOL receivedRandom;
    uint32_t ourRandom;
}
@property (nonatomic, retain) NSMutableDictionary *dictionary_my_device_dimensions;
@property (nonatomic, assign) BOOL isPlayer1;
@property (retain) id <GameModelDelegate> delegate_game_model;
@property (strong, nonatomic) AVAudioPlayer *audio_player;
@property (nonatomic, assign) BOOL less_time_left;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
-(NSMutableArray *)getBoardDimensions;
-(int)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked;
-(void)addCoinToCaptureBlockWithIndex:(int)index ForPlayer:(NSString *)player_at_position;
-(NSMutableDictionary *)updateTimerForPlayer;
-(void) togglePlayer;
-(NSDictionary *)computerTurn;
-(int)anybodyWon;
-(int)timeOverShowWinner;
- (void)sendData:(NSData *)data;
- (void)tryStartGame;
- (void)sendRandomNumber;
-(void)foundPlayer;
-(void)findMatchWithViewController:(UIViewController *)viewController;
-(NSArray *)getArrayOfCoinColors;
-(void)setCoinColors;
-(void)resetGame;
-(void)playSound:(PlaySound)play_sound;
-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;

@end
