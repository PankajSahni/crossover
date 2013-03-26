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

@synthesize array_captured_p1_cgrect;
@synthesize array_captured_p1_coins;
@synthesize array_captured_p2_cgrect;
@synthesize array_captured_p2_coins;

@synthesize int_minutes_p1;
@synthesize int_minutes_p2;
@synthesize int_seconds_p1;
@synthesize int_seconds_p2;
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
-(NSArray *) initialPlayerPositions{
    array_initial_player_positions = [[NSMutableArray alloc] initWithObjects:
                                      @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
                                      @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
                                      @"1",@"1",@"2",@"2",@"2",@"2",@"2",
                                      @"1",@"1",@"1",@"0",@"2",@"2",@"2",
                                      @"1",@"1",@"1",@"1",@"1",@"2",@"2",
                                      @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1",
                                      @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1", nil];
    string_my_turn = @"1";
    
    return array_initial_player_positions;
}

-(int)getCellStatusWithRow:(int)row AndCoumn:(int)column{
    NSString *string_two_dimensional_board_value =
    [[NSString stringWithFormat:@"%d", row]stringByAppendingString:[NSString stringWithFormat:@"%d", column]];
    int index_of_row_and_column =
    [array_two_dimensional_board indexOfObject:string_two_dimensional_board_value];
    return [[array_initial_player_positions objectAtIndex:index_of_row_and_column]intValue] ;
}

-(void)setPlayersCapturedCGRect{
    array_captured_p1_cgrect = [[NSMutableArray alloc] init];
    array_captured_p2_cgrect = [[NSMutableArray alloc] init];
    array_captured_p2_coins = [[NSMutableArray alloc] init];
    array_captured_p1_coins = [[NSMutableArray alloc] init];
    int int_x = 705;
    int int_y_p1 = 300;
    int int_y_p2 = 480;
    for (int i = 0; i <= 1; i ++) {
        
        for (int j = 0; j <= 7; j++) {
            [array_captured_p1_coins addObject:@"0"];
            [array_captured_p2_coins addObject:@"0"];
            CGRect rect_p1 =
            [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:int_x
                                                                          yValue:int_y_p1 width:30 height:30];
            CGRect rect_p2 =
            [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:int_x
                                                                          yValue:int_y_p2 width:30 height:30];
            
            [array_captured_p1_cgrect addObject: [NSValue valueWithCGRect:rect_p2]];
            [array_captured_p2_cgrect addObject: [NSValue valueWithCGRect:rect_p1]];
            int_x = int_x + 35 ;
            
            //
        }
        int_y_p1 = int_y_p1 + 40 ;
        int_y_p2 = int_y_p2 + 40 ;
        int_x = 705;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
