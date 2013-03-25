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
@property (nonatomic, retain) NSMutableArray *array_captured_p1_cgrect;
@property (nonatomic, retain) NSMutableArray *array_captured_p1_coins;
@property (nonatomic, retain) NSMutableArray *array_captured_p2_cgrect;
@property (nonatomic, retain) NSMutableArray *array_captured_p2_coins;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
-(NSMutableArray *)getBoardDimensions;
-(BOOL)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked;

@end
