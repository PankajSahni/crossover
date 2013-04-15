//
//  GameModel.h
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import <Foundation/Foundation.h>
#import "AiEngine.h"
@protocol GameModelDelegate
- (void)sendMove;
- (void)changeMyTurnLabelMessage:(BOOL)status;
@end
@interface GameModel : NSObject{
    AiEngine *aiEngineObject;
    id <GameModelDelegate> delegate_game_model;
}
@property (nonatomic, retain) NSMutableDictionary *dictionary_my_device_dimensions;
@property (nonatomic, retain) NSString *string_player_one_coin;
@property (nonatomic, retain) NSString *string_player_two_coin;
@property (retain) id <GameModelDelegate> delegate_game_model;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
-(NSMutableArray *)getBoardDimensions;
-(int)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked;
-(void)addCoinToCaptureBlockWithIndex:(int)index ForPlayer:(NSString *)player_at_position;
-(NSString *)updateTimerForPlayer;
-(void) togglePlayer;
-(NSDictionary *)computerTurn;
-(int)anybodyWon;
-(int)timeOverShowWinner;
@end
