//
//  GlobalSingleton.h
//  droptwo
//
//  Created by Mac on 09/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSingleton : NSObject
+ (GlobalSingleton *)sharedManager;
@property (nonatomic, retain) NSString *string_my_device_type;
@property (nonatomic, retain) NSMutableDictionary *dictionary_xy_player;
@property (nonatomic, retain) NSMutableArray *array_initial_player_positions;
@property (nonatomic, retain) NSString *string_my_turn;
@property (nonatomic, retain) NSMutableArray *array_two_dimensional_board;
@property (nonatomic, retain) NSMutableArray *array_all_cgrect;

@property (nonatomic, retain) NSMutableArray *array_captured_p1_cgrect;
@property (nonatomic, retain) NSMutableArray *array_captured_p1_coins;
@property (nonatomic, retain) NSMutableArray *array_captured_p2_cgrect;
@property (nonatomic, retain) NSMutableArray *array_captured_p2_coins;

@property (nonatomic, assign) int int_player_one_coin;
@property (nonatomic, assign) int int_player_two_coin;
@property (nonatomic, assign) BOOL bool_sound;

@property (nonatomic, retain) NSString *string_opponent;
@property (nonatomic, assign) BOOL GC;
@property (nonatomic, assign) BOOL GC_my_turn;
@property (nonatomic, assign) int int_minutes_p1;
@property (nonatomic, assign) int int_seconds_p1;
@property (nonatomic, assign) int int_minutes_p2;
@property (nonatomic, assign) int int_seconds_p2;

@property (nonatomic, assign) int int_GC_move;
@property (nonatomic, assign) int int_GC_captured;
@property (nonatomic, assign) int int_GC_newposition;
@property (nonatomic, retain) NSString *string_difficulty;
@property (nonatomic, retain) NSString *me;
@property (nonatomic, retain) NSString *gc_opponent;
-(int)getCellStatusWithRow:(int)row AndCoumn:(int)column;
- (CGRect )getFrameAccordingToDeviceWithXvalue:(float )xVal
                                        yValue:(float )yVal
                                         width:(float )widthVal
                                        height:(float )heightVal;
- (CGPoint)convertPositionWithXOffset:(CGFloat)x withYOffset:(CGFloat)y;
- (int )getXAccordingToDevice:(int )int_x;
-(NSArray *) initialPlayerPositions;


@end
