//
//  GlobalUtility.m
//  droptwo
//
//  Created by Mac on 03/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalUtility.h"

@implementation GlobalUtility
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
    int int_x = 0;
    int int_y = 0;
    for (int i = 0; i <= 6; i ++) {
        
        for (int j = 0; j <= 6; j++) {
         //  NSString *string_dict_keys =  [[NSString stringWithFormat:@"%d", i]stringByAppendingString:[NSString stringWithFormat:@"%d", j]];
           
            

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
        int_x = 0;
    }
    //NSLog(@" %@", dict_temp);
    return array_temp;
}

/*-(NSDictionary *)modelHitWebservice:(NSString *)hit_page with_json:(NSString *)json_data;
{
    
    NSURL *webservice_url = [NSURL URLWithString:[kBaseUrl stringByAppendingString:hit_page]];
    NSMutableURLRequest *webservice_request = [NSMutableURLRequest requestWithURL:webservice_url];
    [webservice_request setHTTPMethod:@"POST"];
    NSString *request_body = [NSString stringWithFormat:@"json_data=%@",[json_data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [webservice_request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response = NULL;
    NSError *error = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:webservice_request returningResponse:&response error:&error];
    NSDictionary *dictionary_from_json_response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    return dictionary_from_json_response;
}*/
/*-(void)facebookPost:(NSDictionary *)dictionary_to_post ToFBFriend:(NSString *)string_fb_id
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed",string_fb_id] parameters:dictionary_to_post HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    }];
}*/
@end
