//
//  GameModel.m
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import "GameModel.h"

@implementation GameModel
@synthesize dictionary_my_device_dimensions;
@synthesize array_two_dimensional_board;
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
    array_two_dimensional_board = [[NSMutableArray alloc ] init ];
    for (int i = 0; i <= 6; i ++) {
        
        for (int j = 0; j <= 6; j++) {
            NSString *string_dict_keys =  [[NSString stringWithFormat:@"%d", j]stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
            [array_two_dimensional_board addObject:string_dict_keys];
            
            
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
@end
