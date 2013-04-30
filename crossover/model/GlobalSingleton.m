//
//  GlobalSingleton.m
//  droptwo
//
//  Created by Mac on 09/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalSingleton.h"

@implementation GlobalSingleton
@synthesize string_my_device_type;
@synthesize dictionary_xy_player;
@synthesize array_initial_player_positions;
@synthesize string_my_turn;
@synthesize array_two_dimensional_board;
@synthesize array_all_cgrect;
@synthesize bool_sound;

@synthesize array_captured_p1_cgrect;
@synthesize array_captured_p1_coins;
@synthesize array_captured_p2_cgrect;
@synthesize array_captured_p2_coins;

@synthesize int_minutes_p1;
@synthesize int_minutes_p2;
@synthesize int_seconds_p1;
@synthesize int_seconds_p2;
@synthesize GC;
@synthesize GC_my_turn;
@synthesize string_opponent;

@synthesize int_player_one_coin;
@synthesize int_player_two_coin;

@synthesize int_GC_captured;
@synthesize int_GC_move;
@synthesize int_GC_newposition;
@synthesize string_difficulty;
@synthesize me;
@synthesize gc_opponent;
static GlobalSingleton *sharedManager; // self

//- (void)dealloc
//{
//	[super dealloc];
//}

+ (GlobalSingleton *)sharedManager
{
	@synchronized(self) {
		
        if (sharedManager == nil)
        {
            sharedManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        /*NSString *sqliteDB = [[NSBundle mainBundle] pathForResource:@"person" ofType:@"sqlite3"];
         if(sqlite3_open([sqliteDB UTF8String], &shareManager) != SQLITE_OK)
         {
         NSLog(@"Failed to open database");
         }*/
    }
    return self;
}


#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
		
        if (sharedManager == nil) {
			
            sharedManager = [super allocWithZone:zone];
			
            return sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}
- (CGRect )getFrameAccordingToDeviceWithXvalue:(float )xVal
                                        yValue:(float )yVal
                                         width:(float )widthVal
                                        height:(float )heightVal{
    
    CGRect resizedFrame = CGRectMake(0,0,0,0);
    
    if([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"]){
        
        resizedFrame = CGRectMake((xVal*480)/1024 ,
                                  (yVal *320)/768,
                                  (widthVal*480)/1024 ,
                                  (heightVal *320)/768);
    }else if([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]){
        
        resizedFrame = CGRectMake((xVal*568)/1024 ,
                                  (yVal *320)/768,
                                  (widthVal*568)/1024 ,
                                  (heightVal *320)/768);
    }
    else{
        
        resizedFrame = CGRectMake(xVal,yVal,widthVal,heightVal);
    }
    return resizedFrame;
    
}

- (int )getXAccordingToDevice:(int )int_x{
    
    float x = int_x;
    if([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"]){
        
       x = (int_x*568)/1024;
    }else if(![[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"ipad5"]){
        x = (int_x*480)/1024;
    }
    else{
        
        
    }
    return (int)x;
    
}
- (CGPoint)convertPositionWithXOffset:(CGFloat)x withYOffset:(CGFloat)y
{
    CGPoint pos = CGPointMake(x, y);
    
    if([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"] ||
       [[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]){
        
        pos = CGPointMake(480*(x/1024),
                          320*(y/768));  
    }
    return pos;
}
-(NSMutableArray *)initialPlayerPositions{
    if (array_initial_player_positions == nil) {
      array_initial_player_positions =  [self getInitialPlayerPositions];
    }
    string_my_turn = @"1";
    return array_initial_player_positions;
}
-(NSMutableArray *)getInitialPlayerPositions{
   return [[NSMutableArray alloc] initWithObjects:
     @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
     @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
     @"1",@"1",@"2",@"2",@"2",@"2",@"2",
     @"1",@"1",@"1",@"0",@"2",@"2",@"2",
     @"1",@"1",@"1",@"1",@"1",@"2",@"2",
     @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1",
     @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1", nil];
}
-(int)getCellStatusWithRow:(int)row AndCoumn:(int)column{
    NSString *string_two_dimensional_board_value =
    [[NSString stringWithFormat:@"%d", row]stringByAppendingString:[NSString stringWithFormat:@"%d", column]];
    int index_of_row_and_column =
    [array_two_dimensional_board indexOfObject:string_two_dimensional_board_value];
    return [[array_initial_player_positions objectAtIndex:index_of_row_and_column]intValue] ;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
