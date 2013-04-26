//
//  ShowWinnerViewController.m
//  crossover
//
//  Created by Shenu Gupta on 31/03/13.
//  Copyright (c) 2013 shenu.gupta2009@gmail.com. All rights reserved.
//

#import "ShowWinnerViewController.h"
#import "GameModel.h"
#import "GlobalSingleton.h"
@interface ShowWinnerViewController ()
@property (readonly) GameModel *gameModelObject;
@end

@implementation ShowWinnerViewController
@synthesize winner;
@synthesize delegate_ShowWinnerViewController;
- (GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
    }
    return gameModelObject;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getPopOver];
    [self animateWinner];
    
}
-(void)animateWinner{
    CGRect cgrect =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:250 yValue:0 width:500 height:400];
   UIImage *image_winner_container = [UIImage imageNamed:@"winner_player1"];
    UIImageView *imageview_winner_container = [[UIImageView alloc] initWithImage:image_winner_container];
    imageview_winner_container.frame = cgrect;
    
   
    UIImage *image_winner;
    if (winner) {
        if (winner == 1) {
            image_winner = [UIImage imageNamed:@"player_1_texta.png"];
        }else{
            if ([[GlobalSingleton sharedManager].string_opponent isEqualToString:@"computer"]) {
                image_winner = [UIImage imageNamed:@"computer_texta.png"];
            }else{
                image_winner = [UIImage imageNamed:@"player_2_texta.png"];
            }
            
        }
    }else{
        image_winner = [UIImage imageNamed:@"player_1_texta.png"];
    }
    UIImageView *imageview_winner =
    [[UIImageView alloc] initWithImage:image_winner];
    cgrect =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:100 yValue:300 width:300 height:80];
    imageview_winner.frame = cgrect;
    [imageview_winner_container addSubview:imageview_winner];
    [self.view addSubview:imageview_winner_container];
}
-(void) getPopOver{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    
    CGRect cgrect_get_popover =
    [self.gameModelObject getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
                                     width:[[device_dimensions valueForKey:@"width"] intValue]
                                   toPixel:[[device_dimensions valueForKey:@"popover_size"] intValue]];
    view_popover =[[UIView alloc] initWithFrame:cgrect_get_popover];
    view_popover.backgroundColor = [UIColor colorWithRed:153.0/255.0f green:93.0/255.0f blue:31.0/255.0f alpha:0.8];
    int logo_width = 400;
    int logo_x = 1024/2 - logo_width/2;
    CGRect cgrect_crossover_logo =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:logo_x yValue:70 width:logo_width height:120];
    UIImage *image_crossover_logo = [UIImage imageNamed:@"crossover.png"];
    UIImageView *imageview_crossover_logo =
    [[UIImageView alloc] initWithImage:image_crossover_logo];
    imageview_crossover_logo.frame = cgrect_crossover_logo;
    [view_popover addSubview:imageview_crossover_logo];
    [self.view addSubview:view_popover];
    int button_width = 240;
    int button_height = 100;
    int button_x = 1024/2 - button_width/2;
    int button_y = 550;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    UIButton *button_new_game = [UIButton buttonWithType:UIButtonTypeCustom];
    button_new_game.frame = rect_temp;
    [button_new_game setBackgroundImage:[UIImage imageNamed:@"new_game.png"]
                               forState:UIControlStateNormal];
    [button_new_game addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_new_game];
}
-(void)startNewGame{
    [self.gameModelObject playSound:kButtonClick];
    [delegate_ShowWinnerViewController new_game];
    [self dismissModalViewControllerAnimated:NO];
    
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

@end
