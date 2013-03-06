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

//@property (nonatomic, retain) NSString *string_my_fb_name;
//@property (nonatomic, retain) NSString *string_my_device_token;
@end
