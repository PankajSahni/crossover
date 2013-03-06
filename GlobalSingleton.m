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

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
