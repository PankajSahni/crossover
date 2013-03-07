//
//  ViewController.m
//  crossover
//
//  Created by Mac on 27/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import <GameKit/GKPlayer.h>
#import <GameKit/GKDefines.h>
#import "GlobalUtility.h"

@interface ViewController ()
@property (readonly) GlobalUtility *globalUtilityObject;
@end

@implementation ViewController

- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
    }
    return globalUtilityObject;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if(error == nil){
            NSLog(@"successfully logged in !!!");
        }else{
            NSLog(@"not logged in");
        }
    } ];*/
    
    
    
    
    //NSLog(@"device_height from controller %@",
      //    [GlobalSingleton sharedManager].string_my_device_type);
    [self getPopOver];
   // NSLog(@"int value %d", [[ [ UIScreen mainScreen ] bounds ].size.height intValue];
}


-(void) getPopOver{
    
    NSDictionary *device_dimensions =
    [self.globalUtilityObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    
    CGRect cgrect_dark_background = [self getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
                                                                     width:[[device_dimensions valueForKey:@"width"] intValue]
                                                                   toPixel:0];
    //NSLog(@"RECT: %@",NSStringFromCGRect(cgrect_dark_background));
    UIView *view_dark_background = [self getDarkBackground:cgrect_dark_background];
    [self.view addSubview:view_dark_background];
    CGRect cgrect_get_popover = [self getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
                                                                 width:[[device_dimensions valueForKey:@"width"] intValue]
                                                               toPixel:[[device_dimensions valueForKey:@"popover_size"] intValue]];
    UIView *view_popover =[[UIView alloc] initWithFrame:cgrect_get_popover];
    view_popover.backgroundColor = [UIColor greenColor];
    [view_dark_background addSubview:view_popover];
    
}

-(UIView *) getDarkBackground:(CGRect)cgrect{
    UIView *view_dark_background = [[UIView alloc] initWithFrame:cgrect];
    view_dark_background.backgroundColor = [UIColor blackColor];
    view_dark_background.alpha = 0.5;
    return view_dark_background;
    
}
-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel{
    int x = pixel;
    int y = pixel;
    int local_width = width - 2*pixel;
    int local_height = height - 2*pixel;
    /*NSLog(@"x %d", x);
     NSLog(@"y %d", y);
     NSLog(@"local_width %d", local_width);
     NSLog(@"local_height %d", local_height);*/
    CGRect rect_local = CGRectMake(x, y, local_width, local_height);
    return rect_local;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}*/

@end
