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
#import "GameModel.h"
#import "GlobalSingleton.h"
#import "BoardUIView.h"
#import "RulesForSingleJumpVsPalyer.h"
#import "RulesForDoubleJumpvsPlayer.h"
@interface ViewController ()
@property (readonly) GameModel *gameModelObject;
@property (readonly) BoardUIView *boardModelObject;
@end

@implementation ViewController

- (BoardUIView *) boardModelObject{
    if(!boardModelObject){
        boardModelObject = [[BoardUIView alloc] init];
    }
    return boardModelObject;
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
    [self getBackground];
    [self getBoard];
    
}


-(void) getBoard{
    

    NSMutableArray *board_dimensions = [self.gameModelObject getBoardDimensions];
    NSArray *array_initial_positions;
    if ([[GlobalSingleton sharedManager].array_initial_player_positions count] == 0) {
       array_initial_positions  = [[GlobalSingleton sharedManager] initialPlayerPositions];
    }else{
        array_initial_positions = [GlobalSingleton sharedManager].array_initial_player_positions;
        for (int i = 0; i <= 48 ; i++) {
          UIButton  *_coin = (UIButton *)[self.view viewWithTag:i+2000];
            [_coin removeFromSuperview];
        }
    }
    NSMutableArray *array_two_dimensional_board = 
    [GlobalSingleton sharedManager].array_two_dimensional_board;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    array_all_cgrect = [[NSMutableArray alloc] init];
    int array_position = 0;
    for (NSDictionary *dict_x_y in board_dimensions) {
        CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:[[dict_x_y valueForKey:@"x"] intValue]
                                                                                           yValue:[[dict_x_y valueForKey:@"y"] intValue]
                                                                                            width:40 height:40];
        
        [array_all_cgrect addObject:[NSValue valueWithCGRect:cgrect_temp]];
        [dict setObject:[NSValue valueWithCGRect:cgrect_temp]
                 forKey:[array_two_dimensional_board objectAtIndex:array_position]];
        coin = [UIButton buttonWithType:UIButtonTypeCustom];
        coin.frame = cgrect_temp;
        coin = [self getCoinWithPlayer:(UIButton *)coin
                             ForPlayer:(NSString *) [array_initial_positions objectAtIndex:array_position]];
        coin.tag = array_position + 2000;
        //NSLog(@"coin.tag %d", coin.tag);
        array_position ++;
        [self.view addSubview:coin];
    }


}
-(UIButton *)getCoinWithPlayer:(UIButton *)button ForPlayer:(NSString *)player{
    NSString *image_player = @"";
    if([player isEqualToString:@"1"]){
        image_player = @"i5.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else if([player isEqualToString:@"2"]){
        image_player = @"i19.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else if([player isEqualToString:@"0"]){
        image_player = @"blanckbtn_big.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
        
    }
    else{
        
    }
    if ([[GlobalSingleton sharedManager].string_my_turn isEqualToString:player]) {
        [self iAmDraggable:button];
    }
    return button;
    
}

- (void) iAmDraggable:(UIButton *) button
{
    
    [button addTarget:self action:@selector(dragBegan:withEvent: )
     forControlEvents: UIControlEventTouchDown];
    [button addTarget:self action:@selector(dragMoving:withEvent: )
     forControlEvents: UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(dragEnded:withEvent: )
     forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
}
- (void) dragBegan:(UIControl *) ctrl withEvent:(UIEvent *) event
{
    tag_coin_picked = ctrl.tag - 2000;
    NSLog(@"tag_coin_picked %d",tag_coin_picked);
    cgrect_drag_started = [[array_all_cgrect objectAtIndex:tag_coin_picked] CGRectValue];
}

- (void) dragMoving:(UIControl *) ctrl withEvent:(UIEvent *) event
{
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:ctrl];
    CGPoint p = [t locationInView:ctrl];
    CGPoint center = ctrl.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    ctrl.center = center;
}

- (IBAction) dragEnded:(UIControl *) ctrl withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint end_point = [touch locationInView:self.view];
    
    
    CGPoint pPrev = [touch previousLocationInView:ctrl];
    CGPoint p = [touch locationInView:ctrl];
    CGPoint center = ctrl.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    ctrl.center = center;
    bool found_in_cgrect = false;
    int int_array_index = 0;
    for (NSValue *cgrect_loop in array_all_cgrect) {
        
        if (CGRectContainsPoint( [cgrect_loop CGRectValue], end_point)) {
            
            NSString *string_coin_picked =
            [[GlobalSingleton sharedManager].array_two_dimensional_board objectAtIndex:tag_coin_picked];
             int start_x =  [[string_coin_picked substringWithRange:NSMakeRange(0, 1)] intValue];
             int start_y =  [[string_coin_picked substringWithRange:NSMakeRange(1, 1)] intValue];
            NSString *string_coin_dropped =
            [[GlobalSingleton sharedManager].array_two_dimensional_board objectAtIndex:int_array_index];
            int end_x =  [[string_coin_dropped substringWithRange:NSMakeRange(0, 1)] intValue];
            int end_y =  [[string_coin_dropped substringWithRange:NSMakeRange(1, 1)] intValue];
            
            int diff_row = start_x - end_x;
            int diff_col = start_y - end_y;
            if(abs(diff_row) <= 1 && abs(diff_col) <=1
               && [RulesForSingleJumpVsPalyer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y]){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                [self togglePlayer:[GlobalSingleton sharedManager].string_my_turn];
                found_in_cgrect = true;
            }else if(
                     ( ( abs(diff_row)==0 && abs(diff_col) == 2) ||
                     ( abs(diff_row)==2 && abs(diff_col) ==0) ||
                     ( abs(diff_row)==2 && abs(diff_col) ==2) )
                && ([RulesForDoubleJumpvsPlayer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y])){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                
                int coin_eliminated = end_x +(diff_row/2)+ (7*(end_y +(diff_col/2)));
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:coin_eliminated withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                //				this.capturedintf = (CapturedAnimation)getContext();
				//capturedintf.capturedAnimation(7*(futurerow +(diffrow/2))+futurecol +(diffcol/2));
                [self togglePlayer:[GlobalSingleton sharedManager].string_my_turn];
                found_in_cgrect = true;
			}
            
            
        }
        int_array_index ++ ;
    }
    
    if(found_in_cgrect == false){
    }
    [self getBoard];
}
-(void) togglePlayer:(NSString *)my_turn{
    if([my_turn isEqualToString:@"1"]){
        [GlobalSingleton sharedManager].string_my_turn = @"2";
    }else{
        [GlobalSingleton sharedManager].string_my_turn = @"1";
    }
}

-(void)authenticateWithGameCenter{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if(error == nil){
            NSLog(@"successfully logged in !!!");
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            [view_popover removeFromSuperview];
            
        }else{
            NSLog(@"not logged in");
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            [view_popover removeFromSuperview];
        }
    }];
}


-(void) getPopOverToStartGame{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x = 1024/2 - button_width/2;
    int button_y = 250;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    button_new_game = [UIButton buttonWithType:UIButtonTypeCustom];
    button_new_game.frame = rect_temp;
    [button_new_game setBackgroundImage:[UIImage imageNamed:@"new_game.png"]
                   forState:UIControlStateNormal];
    [button_new_game addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_new_game];
    
    int new_button_y = button_y + button_height;
    rect_temp = 
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:button_height];
    button_help = [UIButton buttonWithType:UIButtonTypeCustom];
    button_help.frame = rect_temp;
    [button_help setBackgroundImage:[UIImage imageNamed:@"help.png"]
                           forState:UIControlStateNormal];
    [button_help addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_help];
    
    new_button_y = new_button_y + button_height;
    rect_temp = 
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:70];
    
    button_share = [UIButton buttonWithType:UIButtonTypeCustom];
    button_share.frame = rect_temp;
    [button_share setBackgroundImage:[UIImage imageNamed:@"share_btn.png"]
                            forState:UIControlStateNormal];
    [button_share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_share];
    //pankaj
    
    }

-(void) getPopOverToSelectPlayer{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x = 1024/2 - button_width/2;
    int button_y = 250;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    button_vs_computer = [UIButton buttonWithType:UIButtonTypeCustom];
    button_vs_computer.frame = rect_temp;
    [button_vs_computer setBackgroundImage:[UIImage imageNamed:@"playervscomputer.png"]
                               forState:UIControlStateNormal];
    [button_vs_computer addTarget:self action:@selector(playerVsComputer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vs_computer];
    
    int new_button_y = button_y + button_height;
    rect_temp =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:button_height];
    button_vs_gamecenter = [UIButton buttonWithType:UIButtonTypeCustom];
    button_vs_gamecenter.frame = rect_temp;
    [button_vs_gamecenter setBackgroundImage:[UIImage imageNamed:@"GameCenter.png"]
                           forState:UIControlStateNormal];
    [button_vs_gamecenter addTarget:self action:@selector(playerVsGameCenter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vs_gamecenter];
    
    new_button_y = new_button_y + button_height;
    rect_temp =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:70];
    
    button_vs_player = [UIButton buttonWithType:UIButtonTypeCustom];
    button_vs_player.frame = rect_temp;
    [button_vs_player setBackgroundImage:[UIImage imageNamed:@"playervsplayer.png"]
                            forState:UIControlStateNormal];
    [button_vs_player addTarget:self action:@selector(playerVsPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vs_player];
    
}


-(void)startGame{  
    button_new_game.alpha = 0.5;
    button_help.alpha = 0.5;
    button_share.alpha = 0.5;
    view_popover.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         //theView.center = newCenter;
                         button_new_game.alpha = 0;
                         button_help.alpha = 0;
                         button_share.alpha = 0;
                         view_popover.alpha = 0;
                        
                     }
                     completion:^(BOOL finished){
                         // Do other things
                         [button_new_game removeFromSuperview];
                         [button_help removeFromSuperview];
                         [button_share removeFromSuperview];
                         [view_popover removeFromSuperview];
                         [self getPopOverToSelectPlayer];
                     }];
	[UIView commitAnimations];
}
-(void)help{
    NSLog(@"help");
    
}
-(void)share{
    NSLog(@"share");
    
}
-(void)playerVsPlayer{
    //NSLog(@"share");
    button_vs_player.alpha = 0.5;
    button_vs_computer.alpha = 0.5;
    button_vs_gamecenter.alpha = 0.5;
    //view_popover.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         //theView.center = newCenter;
                         button_vs_player.alpha = 0;
                         button_vs_computer.alpha = 0;
                         button_vs_gamecenter.alpha = 0;
                         //view_popover.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [button_vs_player removeFromSuperview];
                         [button_vs_computer removeFromSuperview];
                         [button_vs_gamecenter removeFromSuperview];
                         [view_popover removeFromSuperview];
                         //[self.view addSubview:spinner];
                         //[self authenticateWithGameCenter];
                     }];
	[UIView commitAnimations];
    
}
-(void)playerVsComputer{
    NSLog(@"share");
    
}
-(void)playerVsGameCenter{
    button_vs_player.alpha = 0.5;
    button_vs_computer.alpha = 0.5;
    button_vs_gamecenter.alpha = 0.5;
    //view_popover.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         //theView.center = newCenter;
                         button_vs_player.alpha = 0;
                         button_vs_computer.alpha = 0;
                         button_vs_gamecenter.alpha = 0;
                         //view_popover.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [button_vs_player removeFromSuperview];
                         [button_vs_computer removeFromSuperview];
                         [button_vs_gamecenter removeFromSuperview];
                         
                         [self.view addSubview:spinner];
                         [self authenticateWithGameCenter];
                     }];
	[UIView commitAnimations];
    
}
-(void) getPopOver{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    
    CGRect cgrect_get_popover =
    [self getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
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
}

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

-(void)getBackground{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    CGRect rect_temp = CGRectMake([[device_dimensions valueForKey:@"width"] intValue]/2 - 21 ,
                                  [[device_dimensions valueForKey:@"height"] intValue]/2 - 21,
                                  21,21);
    spinner = [[UIActivityIndicatorView alloc]initWithFrame:rect_temp];
    spinner.frame = rect_temp;
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [spinner startAnimating];
    //NSLog(@"hello");
    UIImage *image_background = [UIImage imageNamed:@"blank.png"];
    UIImageView *imageview_background = [[UIImageView alloc] initWithImage:image_background];
    
    
    rect_temp = CGRectMake(0 , 0,
                           [[device_dimensions valueForKey:@"width"] intValue],
                           [[device_dimensions valueForKey:@"height"] intValue]);
    
    imageview_background.frame = rect_temp;
    
    [self.view addSubview:imageview_background];
    [self.view addSubview:self.boardModelObject];
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
