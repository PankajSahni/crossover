//
//  GameModel.m
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import "GameModel.h"
#import "GlobalSingleton.h"
#import "RulesForSingleJumpVsPalyer.h"
#import "RulesForDoubleJumpvsPlayer.h"
#import "AiEngine.h"
@interface AiEngine ()
@property (readonly) AiEngine *aiEngineObject;
@end
@implementation GameModel

@synthesize dictionary_my_device_dimensions;
@synthesize string_player_one_coin;
@synthesize string_player_two_coin;
//@synthesize delegate_refresh_my_data;
- (AiEngine *) aiEngineObject{
    if(!aiEngineObject){
        aiEngineObject = [[AiEngine alloc] init];
    }
    return aiEngineObject;
}
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type{
    if([device_type isEqualToString:@"iphone"]){
        NSDictionary *device_dimensions = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           @"480", @"width",
                                           @"320", @"height",
                                           @"10", @"popover_size", nil];
        return device_dimensions;
    }else if([device_type isEqualToString:@"ipad"]){
        NSDictionary *device_dimensions = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           @"1024", @"width",
                                           @"768", @"height",
                                           @"20", @"popover_size",
                                           nil];
        return device_dimensions;
    }else{
        NSDictionary *device_dimensions = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           @"568", @"width",
                                           @"320", @"height",
                                           @"10", @"popover_size",
                                           nil];
        return device_dimensions;
    }
    
    
    
}

-(NSMutableArray *)getBoardDimensions{
    string_player_one_coin = @"i5.png";
    string_player_two_coin =  @"i19.png";
    NSMutableArray *array_temp = [[NSMutableArray alloc ] init ];
    int int_x = 52;
    int int_y = 170;
    [GlobalSingleton sharedManager].array_two_dimensional_board = 
    [[NSMutableArray alloc ] init ];
    
    for (int i = 0; i <= 6; i ++) {
        
        for (int j = 0; j <= 6; j++) {
            NSString *string_dict_keys =  [[NSString stringWithFormat:@"%d", j]stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
            [[GlobalSingleton sharedManager].array_two_dimensional_board addObject:string_dict_keys];
            
            
            NSString *x = [NSString stringWithFormat:@"%d", int_x] ;
            NSString *y = [NSString stringWithFormat:@"%d", int_y] ;
            NSDictionary *dimension = [[NSDictionary alloc]initWithObjectsAndKeys:
                                       x,@"x",
                                       y,@"y", nil];
            
            [array_temp addObject: dimension];
            int_x = int_x + 87 ;
            
            //
        }
        int_y = int_y + 87 ;
        int_x = 52;
    }
    return array_temp;
}


-(int)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked{
    int int_array_index = 0;
    int coin_eliminated = 0;
    for (NSValue *cgrect_loop in [GlobalSingleton sharedManager].array_all_cgrect) {
        
        if (CGRectContainsPoint( [cgrect_loop CGRectValue], end_point)) {
            
            NSString *string_coin_picked =
            [[GlobalSingleton sharedManager].array_two_dimensional_board objectAtIndex:tag_coin_picked];
            int start_x =  [[string_coin_picked substringWithRange:NSMakeRange(0, 1)] intValue];
            int start_y =  [[string_coin_picked substringWithRange:NSMakeRange(1, 1)] intValue];
            NSString *string_coin_dropped =
            [[GlobalSingleton sharedManager].array_two_dimensional_board objectAtIndex:int_array_index];
            int end_x =  [[string_coin_dropped substringWithRange:NSMakeRange(0, 1)] intValue];
            int end_y =  [[string_coin_dropped substringWithRange:NSMakeRange(1, 1)] intValue];
            
            int diff_row = start_x - end_x;
            int diff_col = start_y - end_y;
            if(abs(diff_row) <= 1 && abs(diff_col) <=1
               && [RulesForSingleJumpVsPalyer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y]){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                [self togglePlayer];
            }
            if(
                     ( ( abs(diff_row)==0 && abs(diff_col) == 2) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==0) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==2) )
                     && ([RulesForDoubleJumpvsPlayer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y])){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                coin_eliminated = end_x +(diff_row/2)+ (7*(end_y +(diff_col/2)));
			}
            
            
        }
        int_array_index ++ ;
    }
    return coin_eliminated;
}

-(void) togglePlayer{
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]){
        [GlobalSingleton sharedManager].string_my_turn = @"2";
    }else{
        [GlobalSingleton sharedManager].string_my_turn = @"1";
    }
}
-(void)addCoinToCaptureBlockWithIndex:(int)index{
    //NSLog(@"turn %@",[GlobalSingleton sharedManager].string_my_turn);
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]){
        for (int i = 0; i <= 15; i++) {
            if ([[[GlobalSingleton sharedManager].array_captured_p2_coins objectAtIndex:i] isEqualToString:@"0"]) {
                [[GlobalSingleton sharedManager].array_captured_p2_coins replaceObjectAtIndex:i withObject:@"1"];
                break;
            }
        }
    }
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]){
        for (int i = 0; i <= 15; i++) {
            if ([[[GlobalSingleton sharedManager].array_captured_p1_coins objectAtIndex:i] isEqualToString:@"0"]) {
                [[GlobalSingleton sharedManager].array_captured_p1_coins replaceObjectAtIndex:i withObject:@"1"];
                break;
            }
        }
    }
}


-(NSString *)updateTimerForPlayer{
    NSString* timeNow;
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]){
        if ([GlobalSingleton sharedManager].int_seconds_p1 == 00)
        {
            [GlobalSingleton sharedManager].int_seconds_p1 = 60;
            [GlobalSingleton sharedManager].int_minutes_p1 --;
        }
        
        [GlobalSingleton sharedManager].int_seconds_p1 --;
        if ([GlobalSingleton sharedManager].int_minutes_p1==0 &&
            [GlobalSingleton sharedManager].int_seconds_p1==0) {
        }
        timeNow = [NSString stringWithFormat:@"%02d:%02d",
                             [GlobalSingleton sharedManager].int_minutes_p1,
                             [GlobalSingleton sharedManager].int_seconds_p1];
    }
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]){
        if ([GlobalSingleton sharedManager].int_seconds_p1 == 00)
        {
            [GlobalSingleton sharedManager].int_seconds_p1 = 60;
            [GlobalSingleton sharedManager].int_minutes_p1 --;
        }
        
        [GlobalSingleton sharedManager].int_seconds_p1 --;
        if ([GlobalSingleton sharedManager].int_minutes_p1==0 &&
            [GlobalSingleton sharedManager].int_seconds_p1==0) {
        }
         timeNow  = [NSString stringWithFormat:@"%02d:%02d",
                             [GlobalSingleton sharedManager].int_minutes_p1,
                             [GlobalSingleton sharedManager].int_seconds_p1];
    }
    return timeNow;
}

-(NSDictionary *)computerTurn{
    
   NSDictionary *dict_computer_turn = [self.aiEngineObject playerOne];
    return dict_computer_turn;
}

-(int)anybodyWon{
    BOOL p1_coin_exist = FALSE;
    BOOL p2_coin_exist = FALSE;
    for (int i = 0; i <= 48; i++) {
        NSString *player =
        [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i];
        if ([player isEqualToString:@"1"]) {
            p1_coin_exist = TRUE;
        }
        if ([player isEqualToString:@"2"]) {
            p2_coin_exist = TRUE;
        }
    }
    if (p1_coin_exist == FALSE) {
        return 2;
    }
    else if (p2_coin_exist == FALSE) {
        return 1;
    }
    else{
        return 0;
    }
}
-(int)timeOverShowWinner{
    int p1 = 0;
    int p2 = 0;
    int return_winner = 0;
    for (int i = 0; i <= 48; i++) {
        NSString *player =
        [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i];
        if ([player isEqualToString:@"1"]) {
            p1 ++;
        }
        if ([player isEqualToString:@"2"]) {
            p2 ++;
        }
    }
    if (p1==0 && p2==0) {
        return_winner = 0;
    }
    else if (p1 > p2) {
        return_winner = 1;
    }
    else if(p1 < p2){
        return_winner = 2;
    }else{
        return_winner = 0;
    }
    return return_winner;
}
@end
