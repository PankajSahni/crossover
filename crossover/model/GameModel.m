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
@implementation GameModel
@synthesize dictionary_my_device_dimensions;

//@synthesize delegate_refresh_my_data;

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


-(BOOL)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked{
    int int_array_index = 0;
    BOOL return_value;
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
                [self togglePlayer:[GlobalSingleton sharedManager].string_my_turn];
                return_value = true;
            }else if(
                     ( ( abs(diff_row)==0 && abs(diff_col) == 2) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==0) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==2) )
                     && ([RulesForDoubleJumpvsPlayer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y])){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                
                int coin_eliminated = end_x +(diff_row/2)+ (7*(end_y +(diff_col/2)));
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:coin_eliminated withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                //				this.capturedintf = (CapturedAnimation)getContext();
				//capturedintf.capturedAnimation(7*(futurerow +(diffrow/2))+futurecol +(diffcol/2));
                [self togglePlayer:[GlobalSingleton sharedManager].string_my_turn];
                return_value = true;
			}else {
                return_value = false;
            }
            
            
        }
        int_array_index ++ ;
    }
    return return_value;
}

-(void) togglePlayer:(NSString *)my_turn{
    if([my_turn isEqualToString:@"1"]){
        [GlobalSingleton sharedManager].string_my_turn = @"2";
    }else{
        [GlobalSingleton sharedManager].string_my_turn = @"1";
    }
}


@end
