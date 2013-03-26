//
//  GameModel.h
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject
@property (nonatomic, retain) NSMutableDictionary *dictionary_my_device_dimensions;
@property (nonatomic, retain) NSString *string_player_one_coin;
@property (nonatomic, retain) NSString *string_player_two_coin;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
-(NSMutableArray *)getBoardDimensions;
-(int)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked;
-(void)addCoinToCaptureBlockWithIndex:(int)index;
-(NSString *)updateTimerForPlayer;
-(void) togglePlayer;
@end
