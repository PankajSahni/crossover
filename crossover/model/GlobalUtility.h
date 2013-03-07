//
//  GlobalUtility.h
//  droptwo
//
//  Created by Mac on 03/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalUtility : NSObject
@property (nonatomic, retain) NSMutableDictionary *dictionary_my_device_dimensions;
//@property (nonatomic, retain)id delegate_refresh_my_data;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
/*-(NSDictionary *)modelHitWebservice:(NSString *)web_url with_json:(NSString *)json_data;
-(void)facebookPost:(NSDictionary *)dictionary_to_post ToFBFriend:(NSString *)string_fb_id;*/
@end
