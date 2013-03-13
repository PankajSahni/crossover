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

-(NSArray *) initialPlayerPositions{
    NSArray *temp = [ [NSArray alloc] initWithObjects:
    @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
              @"-1",@"-1",@"2",@"2",@"2",@"-1",@"-1",
              @"1",@"1",@"2",@"2",@"2",@"2",@"2",
              @"1",@"1",@"1",@"0",@"2",@"2",@"2",
              @"1",@"1",@"1",@"1",@"1",@"2",@"2",
              @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1",
              @"-1",@"-1",@"1",@"1",@"1",@"-1",@"-1", nil];
    return temp;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
