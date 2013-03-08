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
#import "GameModel.h"
#import "GlobalSingleton.h"
@interface ViewController ()
@property (readonly) GlobalUtility *globalUtilityObject;
@property (readonly) GameModel *gameModelObject;
@end

@implementation ViewController
- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
    }
    return globalUtilityObject;
}
- (GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
    }
    return gameModelObject;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"hello");
    UIImage *image_background = [UIImage imageNamed:@"images/blank.png"];
    UIImageView *imageview_background = [[UIImageView alloc] initWithImage:image_background];
    
    NSDictionary *device_dimensions =
    [self.globalUtilityObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    CGRect rect_temp = CGRectMake(0 , 0,
                                  [[device_dimensions valueForKey:@"width"] intValue],
                                  [[device_dimensions valueForKey:@"height"] intValue]);

    imageview_background.frame = rect_temp;
    
    /* temp */
   UIImage *image_background1 = [UIImage imageNamed:@"images/hard.png"];
    UIImageView *imageview_background1 = [[UIImageView alloc] initWithImage:image_background1];
    rect_temp = CGRectMake(100 , 100,200,200);
    imageview_background1.frame = rect_temp;
    
    /*temp */
    [self.view addSubview:imageview_background];
    [self.view addSubview:imageview_background1];
    //[self.view addSubview:imageview_main_background];
    
    /*[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if(error == nil){
            NSLog(@"successfully logged in !!!");
        }else{
            NSLog(@"not logged in");
        }
    } ];*/
    
    
    [self getPopOverToStartPlayer];
}


-(void) getPopOverToStartPlayer{
    [self getPopOver];
    
    int button_width = 240;
    int button_height = 100;
    int button_x = 390;
    int button_y = 200;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    button_new_game = [UIButton buttonWithType:UIButtonTypeCustom];
    button_new_game.frame = rect_temp;
    [button_new_game setBackgroundImage:[UIImage imageNamed:@"images/new_game.png"]
                   forState:UIControlStateNormal];
    [button_new_game addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_new_game];
    
    int new_button_y = button_y + button_height;
    rect_temp = 
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:button_height];
    button_help = [UIButton buttonWithType:UIButtonTypeCustom];
    button_help.frame = rect_temp;
    [button_help setBackgroundImage:[UIImage imageNamed:@"images/help.png"]
                           forState:UIControlStateNormal];
    [button_help addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    //NSLog(@"buttons %@", button_help);
    [self.view addSubview:button_help];
    
    new_button_y = new_button_y + button_height;
    rect_temp = 
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:70];
    
    button_share = [UIButton buttonWithType:UIButtonTypeCustom];
    button_share.frame = rect_temp;
    [button_share setBackgroundImage:[UIImage imageNamed:@"images/share_btn.png"]
                            forState:UIControlStateNormal];
    [button_share addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_share];
    //pankaj
    
    }

-(void)startGame{
    NSLog(@"move");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:NO];
	[button_new_game removeFromSuperview];
    [button_help removeFromSuperview];
    [button_share removeFromSuperview];
	[view_popover removeFromSuperview];
	
    
	[UIView commitAnimations];
}

-(void) getPopOver{
    NSDictionary *device_dimensions =
    [self.globalUtilityObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    
    CGRect cgrect_get_popover =
    [self getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
                                                                 width:[[device_dimensions valueForKey:@"width"] intValue]
                                                               toPixel:[[device_dimensions valueForKey:@"popover_size"] intValue]];
    view_popover =[[UIView alloc] initWithFrame:cgrect_get_popover];
   view_popover.backgroundColor = [UIColor colorWithRed:153.0/255.0f green:93.0/255.0f blue:31.0/255.0f alpha:0.5];
    [self.view addSubview:view_popover];
}
/*-(UIView *) getDarkBackground:(CGRect)cgrect{
    UIView *view_dark_background = [[UIView alloc] initWithFrame:cgrect];
    view_dark_background.backgroundColor = [UIColor blackColor];
    view_dark_background.alpha = 0.5;
    return view_dark_background;
    
}*/
-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel{
    int x = pixel;
    int y = pixel;
    int local_width = width - 2*pixel;
    int local_height = height - 2*pixel;
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
