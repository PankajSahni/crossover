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
#import "ShowWinnerViewController.h"
#import "AppDelegate.h"
#import "iPadCGRect.h"
#import "iPhoneCGRect.h"
#import "SettingsViewController.h"
#import "MyEnums.h"
/*#import "SHK.h"
#import "SHKActionSheet.h"
#import "SHKItem.h"*/
@interface GameController ()
@property (readonly) GameModel *gameModelObject;
@property (readonly) BoardUIView *boardModelObject;
@property (readonly) SettingsViewController *settingsViewControllerObject;
@end

@implementation GameController
-(BoardUIView *) boardModelObject{
    if(!boardModelObject){
        boardModelObject = [[BoardUIView alloc] init];
    }
    return boardModelObject;
}
-(GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
        [GlobalSingleton sharedManager].delegate_game_model = self;
    }
    return gameModelObject;
}

-(SettingsViewController *) settingsViewControllerObject{
    if(!settingsViewControllerObject){
        settingsViewControllerObject = [[SettingsViewController alloc] init];
        settingsViewControllerObject.delegate_SettingsViewController = self;
    }
    return settingsViewControllerObject;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self createCGRectObjectForDevice];
    [self startSpinnerOnDidLoad];
    [self.view addSubview:self.boardModelObject];
    [self getBoard];
    [self getAllOptionButtonsForUser];
    [self setPlayerLabels];
    [GlobalSingleton sharedManager].bool_sound = TRUE;
    
    [self getPopOverToStartGame];
}
-(void)createCGRectObjectForDevice{
if ([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"] ||
    [[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]) {
    cgRectObject = [[iPhoneCGRect alloc] init];
   }else{
    cgRectObject = [[iPadCGRect alloc] init];
   }
}


#pragma mark DelegateGameModelCalls
-(void)removePopoverAndSpinner{
    [view_popover removeFromSuperview];
    [spinner removeFromSuperview];
    [self refreshCapturedBlocks];
}
-(void)addPopoverAndSpinner{
    [self.view addSubview:view_popover];
    [self.view addSubview:spinner];
}
- (void)changeMyTurnLabelMessage:(BOOL)status{
    
    if (status) {
        
        [debugLabel setText:@"Active: Your Turn"];
    }else{
        [debugLabel setText:@"Inactive: opposite player's turn"];
    }
}
- (void)initialSetUpMessagesForLabel:(NSString *)string{
    [debugLabel setText:string];
}
-(void)updateGCPlayerLabels{
    //timer_label = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blinkActiveGCPlayer) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:timer_label forMode:NSDefaultRunLoopMode];
    if (self.gameModelObject.isPlayer1) {
        label_player_one.text = [[GlobalSingleton sharedManager].me stringByAppendingString:@": Player One"];
        label_player_two.text = [[GlobalSingleton sharedManager].gc_opponent stringByAppendingString:@": Player Two"];
    }else{
        label_player_one.text = [[GlobalSingleton sharedManager].gc_opponent stringByAppendingString:@": Player One"];
        label_player_two.text = [[GlobalSingleton sharedManager].me stringByAppendingString:@": Player Two"];
    }
}
-(void)blinkActiveGCPlayer{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    if ([GlobalSingleton sharedManager].GC_my_turn) {
        label_player_two.alpha = 0.0;
    }else{
        label_player_one.alpha = 0.0;
    }
    [UIView commitAnimations];
}
-(void)addLabelToShowMultiplayerGameStatus{
    [spinner removeFromSuperview];
    [view_popover removeFromSuperview];
    NSDictionary *device_dimensions =
    [self.gameModelObject
     getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    CGRect rect_temp =
    CGRectMake([[device_dimensions valueForKey:@"width"] intValue]/2 + 121 ,
               [[device_dimensions valueForKey:@"height"] intValue]/2 + 21,
               300,20);
    debugLabel = [[UILabel alloc] initWithFrame:rect_temp];
    [self.view addSubview:debugLabel];
}
-(void)matchMakingCancelledByUser{
    [spinner removeFromSuperview];
    [view_popover removeFromSuperview];
    [self getPopOverToStartGame];
}
#pragma mark SettingsViewControllerDelegateCalls
-(void)dismissedModal{
    [self getBoard];
    [self refreshCapturedBlocks];
    [self StartTimer];
}
-(void)updateUIOnReset{
    [self.boardModelObject getCapturedPlayers];
    label_player_one.text = @"";
    label_player_two.text = @"";
    time_label_P1.text = @"";
    time_label_P2.text = @"";
    time_label_P1 = nil;
    timer_label = nil;
    timer = nil;
    [self.gameModelObject playSound:kButtonClick];
    [imageview_captured removeFromSuperview];
    [self removeRefreshSubViews];
    [view_popover removeFromSuperview];
    [self refreshCapturedBlocks];
    [self getBoard];
    [self setPlayerLabels];
}
#pragma mark Animations
-(void)animateEliminatedCapturedCoinWithIndex:(int)captured{
    
    CGRect move_to;
    NSString *player_at_position = [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:captured];
    if ([player_at_position isEqualToString:@"1"]) {
        for (int i = 0; i <= 15; i ++) {
            if([[[GlobalSingleton sharedManager].array_captured_p1_coins objectAtIndex:i] isEqualToString:@"0"]){
                move_to = [[[GlobalSingleton sharedManager].array_captured_p1_cgrect objectAtIndex:i] CGRectValue];
                break;
            }
        }
    }if ([player_at_position isEqualToString:@"2"]) {
        for (int i = 0; i <= 15; i ++) {
            if([[[GlobalSingleton sharedManager].array_captured_p2_coins objectAtIndex:i] isEqualToString:@"0"]){
                move_to = [[[GlobalSingleton sharedManager].array_captured_p2_cgrect objectAtIndex:i] CGRectValue];
                break;
            }
        }
    }
    [self.gameModelObject addCoinToCaptureBlockWithIndex:captured ForPlayer:player_at_position];
    if (![GlobalSingleton sharedManager].GC) {
        [self.gameModelObject togglePlayer];
    }
    
    [self getBoard];
    UIImage *image_blank_coin = [UIImage imageNamed:@"blank_coin.png"];
    UIImageView *imageview_blank_coin = [[UIImageView alloc] initWithImage:image_blank_coin];
    UIButton *button = (UIButton *)[self.view viewWithTag:captured+2000];
    imageview_blank_coin.frame = button.frame;
    [self.view insertSubview:imageview_blank_coin belowSubview:button];
    [self.gameModelObject playSound:kCapture];
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         UIButton *button = (UIButton *)[self.view viewWithTag:captured+2000];
                         button.frame = move_to;
                         

                     }
                     completion:^(BOOL finished){
                         [[GlobalSingleton sharedManager].array_initial_player_positions
                          replaceObjectAtIndex:captured withObject:@"0"];
                         [self getBoard];
                         if([[GlobalSingleton sharedManager].string_opponent isEqualToString:@"computer"] && [[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]){
                             NSDictionary *computer_turn = [self.gameModelObject computerTurn];
                             [self animateComputerOrGameCenterMove:computer_turn];
                         }
                         [self refreshCapturedBlocks];
                         
                     }];
    
	[UIView commitAnimations];
    
    
}
-(void)animateComputerOrGameCenterMove:(NSDictionary *)opposition_turn{
    
    int move = [[opposition_turn objectForKey:@"move"] intValue];
    int newposition = [[opposition_turn objectForKey:@"newposition"] intValue];
    int captured = 0;
    if ([opposition_turn objectForKey:@"captured"]) {
        captured = [[opposition_turn objectForKey:@"captured"] intValue];
    }
    NSString *opposite_player;
    if ([GlobalSingleton sharedManager].GC) {
        NSLog(@"self.gameModelObject.isPlayer1 %d",self.gameModelObject.isPlayer1);
        if ([GlobalSingleton sharedManager].isPlayer1) {
            
            opposite_player = @"2";
        }else{
            
            opposite_player = @"1";
        }
    }else{
        
        opposite_player = @"2";
    }
    
    CGRect move_to = [[[GlobalSingleton sharedManager].array_all_cgrect objectAtIndex:newposition] CGRectValue];
    UIImage *image_blank_coin = [UIImage imageNamed:@"blank_coin.png"];
    UIImageView *imageview_blank_coin = [[UIImageView alloc] initWithImage:image_blank_coin];
    UIButton *button = (UIButton *)[self.view viewWithTag:move+2000];
    imageview_blank_coin.frame = button.frame;
    [self.view insertSubview:imageview_blank_coin belowSubview:button];
    [self.gameModelObject playSound:kMove];
    [UIView animateWithDuration:1.0
                     animations:^{
                         UIButton *move_coin = (UIButton *)[self.view viewWithTag:move+2000];
                         move_coin.frame = move_to;
                         
                     }
                     completion:^(BOOL finished){
                         [[GlobalSingleton sharedManager].array_initial_player_positions
                          replaceObjectAtIndex:move withObject:@"0"];
                         [[GlobalSingleton sharedManager].array_initial_player_positions
                          replaceObjectAtIndex:newposition withObject:opposite_player];
                         
                         if (captured) {
                             
                             [self animateEliminatedCapturedCoinWithIndex:captured];
                             
                         }else {
                             if (![GlobalSingleton sharedManager].GC) {
                                 [self.gameModelObject togglePlayer];
                             }
                             [self getBoard];
                         }
                     }];
	[UIView commitAnimations];
    
}

-(void)getTimer{
    [GlobalSingleton sharedManager].int_minutes_p1 = 2;
    [GlobalSingleton sharedManager].int_seconds_p1 = 0;
    [GlobalSingleton sharedManager].int_minutes_p2 = 2;
    [GlobalSingleton sharedManager].int_seconds_p2 = 0;
    
    CGRect rect_temp = [cgRectObject labelPlayerOneCGRect];
    time_label_P1 = [[UILabel alloc] initWithFrame: rect_temp];
    [self.view addSubview:time_label_P1];
    UIFont *font_digital = [UIFont
                            fontWithName:@"Let's go Digital"
                            size:12];
    [time_label_P1 setFont:font_digital];
    time_label_P1.textColor = [UIColor whiteColor];
    time_label_P1.backgroundColor = [UIColor clearColor];
    time_label_P1.text = @"02:00";
    
    rect_temp = [cgRectObject labelPlayerTwoCGRect];
    time_label_P2 = [[UILabel alloc] initWithFrame: rect_temp];
    time_label_P2.textColor = [UIColor whiteColor];
    time_label_P2.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:time_label_P2];
    [time_label_P2 setFont:font_digital];
    time_label_P2.text = @"02:00";
}
#pragma mark Events
-(void)startGame{
    [self.gameModelObject playSound:kButtonClick];
    button_new_game.alpha = 0.5;
    button_help.alpha = 0.5;
    button_share.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         button_new_game.alpha = 0;
                         button_help.alpha = 0;
                         button_share.alpha = 0;
                         
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
    [self getPopOverToHelp];
}
-(void)showWinner:(int)winner{
    [timer invalidate];
    ShowWinnerViewController *showWinner = [[ShowWinnerViewController alloc] init];
    showWinner.delegate_ShowWinnerViewController = self;
    showWinner.winner = winner;
    [self presentModalViewController:showWinner animated:YES];
}
-(void)share{
    NSLog(@"share");
	/*NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!"];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];*/
}
-(void)playerVsPlayer{
    [self.gameModelObject playSound:kButtonClick];
    button_vs_player.alpha = 0.5;
    button_vs_computer.alpha = 0.5;
    button_vs_gamecenter.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         button_vs_player.alpha = 0;
                         button_vs_computer.alpha = 0;
                         button_vs_gamecenter.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [button_vs_player removeFromSuperview];
                         [button_vs_computer removeFromSuperview];
                         [button_vs_gamecenter removeFromSuperview];
                         [view_popover removeFromSuperview];
                         [self getTimer];
                         [self StartTimer];
                     }];
	[UIView commitAnimations];
    
}
-(void)playerVsComputer{
    [self.gameModelObject playSound:kButtonClick];
    button_vs_player.alpha = 0.5;
    button_vs_computer.alpha = 0.5;
    button_vs_gamecenter.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         button_vs_player.alpha = 0;
                         button_vs_computer.alpha = 0;
                         button_vs_gamecenter.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [button_vs_player removeFromSuperview];
                         [button_vs_computer removeFromSuperview];
                         [button_vs_gamecenter removeFromSuperview];
                         [view_popover removeFromSuperview];
                         [label_player_two setText:@"computer"];
                         [self getPopOverToSelectDifficulty];
                     }];
	[UIView commitAnimations];
    [GlobalSingleton sharedManager].string_opponent = @"computer";
}

- (void) dragBegan:(UIControl *) ctrl withEvent:(UIEvent *) event{
    tag_coin_picked = ctrl.tag - 2000;
    
    UIImage *image_blank_coin = [UIImage imageNamed:@"blank_coin.png"];
    UIImageView *imageview_blank_coin = [[UIImageView alloc] initWithImage:image_blank_coin];
    UIButton *button = (UIButton *)[self.view viewWithTag:ctrl.tag];
    imageview_blank_coin.frame = button.frame;
    [self.view insertSubview:imageview_blank_coin belowSubview:button];
}
- (void) dragMoving:(UIControl *) ctrl withEvent:(UIEvent *) event{
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:ctrl];
    CGPoint p = [t locationInView:ctrl];
    CGPoint center = ctrl.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    [self.view bringSubviewToFront:ctrl];
    ctrl.center = center;
}
- (IBAction) dragEnded:(UIControl *) ctrl withEvent:(UIEvent *) event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint end_point = [touch locationInView:self.view];
    int captured = [self.gameModelObject
                    validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked];
    if(captured){
        [self animateEliminatedCapturedCoinWithIndex:captured];
    }else{
        [self getBoard];
        if([[GlobalSingleton sharedManager].string_opponent isEqualToString:@"computer"] && [[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]){
            NSDictionary *computer_turn = [self.gameModelObject computerTurn];
            [self animateComputerOrGameCenterMove:computer_turn];
            
        }
    }
}

-(void)playerVsGameCenter{
    [self.gameModelObject playSound:kButtonClick];
    button_vs_player.alpha = 0.5;
    button_vs_computer.alpha = 0.5;
    button_vs_gamecenter.alpha = 0.5;
    [UIView animateWithDuration:1.0
                     animations:^{
                         button_vs_player.alpha = 0;
                         button_vs_computer.alpha = 0;
                         button_vs_gamecenter.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [button_vs_player removeFromSuperview];
                         [button_vs_computer removeFromSuperview];
                         [button_vs_gamecenter removeFromSuperview];
                         [self.view addSubview:spinner];
                         [[GCTurnBasedMatchHelper sharedInstance] authenticateLocalUser];
                         [GlobalSingleton sharedManager].GC = TRUE;
                         AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                         [GlobalSingleton sharedManager].game_uiviewcontroller = delegate.viewController;
                     }];
	[UIView commitAnimations];
    
}
-(void) StartTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)timerTick{
    NSDictionary *dictionary_time_now = [[self gameModelObject] updateTimerForPlayer];
    [self blinkActivePlayer];
    time_label_P1.text = [dictionary_time_now objectForKey:@"player_one"];
    time_label_P2.text = [dictionary_time_now objectForKey:@"player_two"];
}
-(void)blinkActivePlayer{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    if ([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]) {
        label_player_two.alpha = 0.0;
    }else{
        label_player_one.alpha = 0.0;
    }
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    label_player_one.alpha = 1.0;
    label_player_two.alpha = 1.0;
}
-(void)pause{
    [self.gameModelObject playSound:kButtonClick];
    [timer invalidate];
    [self getPopoverToPause];
}
-(void)refresh{
    [self.gameModelObject playSound:kButtonClick];
    [timer invalidate];
    [self getPopoverToRefresh];
}

- (void)settings{
    //[self.gameModelObject playSound:kButtonClick];
    [timer invalidate];
    [self presentModalViewController:self.settingsViewControllerObject animated:NO];
}
-(void)mainmenu{
    [self.gameModelObject playSound:kButtonClick];
    [timer invalidate];
    [self getPopoverForMainmenu];
}
#pragma mark Backgrounds
-(void) getBoard{
    [self.gameModelObject setCoinColors];
    tag_coin_picked = 0;
    NSMutableArray *board_dimensions = [self.gameModelObject getBoardDimensions];
    NSArray *array_initial_positions;
    if ([[GlobalSingleton sharedManager].array_initial_player_positions count] == 0) {
        
        array_initial_positions  = [[GlobalSingleton sharedManager] initialPlayerPositions];
    }else{
        array_initial_positions = [GlobalSingleton sharedManager].array_initial_player_positions;
    }
    for (int i = 0; i <= 48 ; i++) {
        UIButton  *_coin = (UIButton *)[self.view viewWithTag:i+2000];
        [_coin removeFromSuperview];
    }
    NSMutableArray *array_two_dimensional_board =
    [GlobalSingleton sharedManager].array_two_dimensional_board;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [GlobalSingleton sharedManager].array_all_cgrect = [[NSMutableArray alloc] init];
    int array_position = 0;
    NSDictionary *cordinates = [cgRectObject arrayCoinsCGRect];
    int width = [[cordinates objectForKey:@"width"] floatValue];
    int height = [[cordinates objectForKey:@"height"] floatValue];
    for (NSDictionary *dict_x_y in board_dimensions) {
        
        CGRect cgrect_temp = CGRectMake([[dict_x_y valueForKey:@"x"] floatValue],
                                        [[dict_x_y valueForKey:@"y"] floatValue], width, height);
                                                                                        
        [[GlobalSingleton sharedManager].array_all_cgrect
         addObject:[NSValue valueWithCGRect:cgrect_temp]];
        [dict setObject:[NSValue valueWithCGRect:cgrect_temp]
                 forKey:[array_two_dimensional_board objectAtIndex:array_position]];
        coin = [UIButton buttonWithType:UIButtonTypeCustom];
        coin.frame = cgrect_temp;
        coin = [self getCoinWithPlayer:(UIButton *)coin
                             ForPlayer:(NSString *) [array_initial_positions objectAtIndex:array_position]];
        coin.tag = array_position + 2000;
        array_position ++;
        [self.view addSubview:coin];
    }
    int winner = [self.gameModelObject anybodyWon];
    if (winner) {
        [self showWinner:(int)winner];
    }
}
-(void)getPopOver{
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
}
-(void)new_game{
    [self yes_mainmenu];
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

-(void)getPopoverToPause{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x = 1024/2 - button_width/2;
    int button_y = 350;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y 
                                                                                      width:button_width height:button_height];
    
    button_resume = [UIButton buttonWithType:UIButtonTypeCustom];
    button_resume.frame = rect_temp;
    [button_resume setBackgroundImage:[UIImage imageNamed:@"button_resume.png"]
                                  forState:UIControlStateNormal];
    [button_resume addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_resume];
}
-(void)resume{
    [self.gameModelObject playSound:kButtonClick];
    [self StartTimer];
    [button_resume removeFromSuperview];
    [view_popover removeFromSuperview];
}
-(void)getPopoverForMainmenu{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x_1 = 200;
    int button_x_2 = 600;
    int button_y = 350;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x_1 yValue:button_y 
                                                                                      width:button_width height:button_height];
    
    button_yes = [UIButton buttonWithType:UIButtonTypeCustom];
    button_yes.frame = rect_temp;
    [button_yes setBackgroundImage:[UIImage imageNamed:@"button_yes.png"]
                          forState:UIControlStateNormal];
    [button_yes addTarget:self action:@selector(yes_mainmenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_yes];
    rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x_2 yValue:button_y width:button_width height:button_height];
    
    button_no = [UIButton buttonWithType:UIButtonTypeCustom];
    button_no.frame = rect_temp;
    [button_no setBackgroundImage:[UIImage imageNamed:@"button_no.png"]
                         forState:UIControlStateNormal];
    [button_no addTarget:self action:@selector(no) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_no];
}
-(void)getPopoverToRefresh{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x_1 = 200;
    int button_x_2 = 600;
    int button_y = 350;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x_1 yValue:button_y 
                                                                                      width:button_width height:button_height];
    
    button_yes = [UIButton buttonWithType:UIButtonTypeCustom];
    button_yes.frame = rect_temp;
    [button_yes setBackgroundImage:[UIImage imageNamed:@"button_yes.png"]
                      forState:UIControlStateNormal];
    [button_yes addTarget:self action:@selector(yes_refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_yes];
    rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x_2 yValue:button_y width:button_width height:button_height];
    
    button_no = [UIButton buttonWithType:UIButtonTypeCustom];
    button_no.frame = rect_temp;
    [button_no setBackgroundImage:[UIImage imageNamed:@"button_no.png"]
                          forState:UIControlStateNormal];
    [button_no addTarget:self action:@selector(no) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_no];
}
-(void)yes_refresh{
    [self.gameModelObject resetGame];
     [self getTimer];
    [self StartTimer];
    //[timer invalidate];
    //[self StartTimer];
}
-(void)yes_mainmenu{
    
    [GlobalSingleton sharedManager].string_opponent = nil;
    [self.gameModelObject resetGame];
    [self getPopOverToStartGame];
}
-(void)no{
    [self.gameModelObject playSound:kButtonClick];
    [self StartTimer];
    [self removeRefreshSubViews];
    [view_popover removeFromSuperview];
}
-(void)removeRefreshSubViews{
    [button_yes removeFromSuperview];
    [button_no removeFromSuperview];
}
-(void)getPopOverToSelectPlayer{
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
    [button_vs_gamecenter setBackgroundImage:[UIImage imageNamed:@"button_game_center.png"]
                                    forState:UIControlStateNormal];
    [button_vs_gamecenter addTarget:self action:@selector(playerVsGameCenter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vs_gamecenter];
    
    new_button_y = new_button_y + button_height + 50;
    rect_temp =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:70];
    
    button_vs_player = [UIButton buttonWithType:UIButtonTypeCustom];
    button_vs_player.frame = rect_temp;
    [button_vs_player setBackgroundImage:[UIImage imageNamed:@"playervsplayer.png"]
                                forState:UIControlStateNormal];
    [button_vs_player addTarget:self action:@selector(playerVsPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vs_player];
    
}
-(void)getPopOverToHelp{
    [button_new_game removeFromSuperview];
    [button_help removeFromSuperview];
    [button_share removeFromSuperview];
    int button_width = 60;
    int button_height = 60;
    int button_x = 920;
    int button_y = 50;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    button_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    button_cancel.frame = rect_temp;
    [button_cancel setBackgroundImage:[UIImage imageNamed:@"button_cancel.png"]
                                  forState:UIControlStateNormal];
    [button_cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_cancel];
}
-(void)cancel{
    [button_cancel removeFromSuperview];
    [view_popover removeFromSuperview];
    [self getPopOverToStartGame];
}
-(void)getPopOverToSelectDifficulty{
    [self getPopOver];
    int button_width = 240;
    int button_height = 100;
    int button_x = 1024/2 - button_width/2;
    int button_y = 250;
    CGRect rect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:button_y width:button_width height:button_height];
    
    button_simple = [UIButton buttonWithType:UIButtonTypeCustom];
    button_simple.frame = rect_temp;
    [button_simple setBackgroundImage:[UIImage imageNamed:@"button_simple.png"]
                                  forState:UIControlStateNormal];
    [button_simple addTarget:self action:@selector(simple) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_simple];
    
    int new_button_y = button_y + button_height;
    rect_temp =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:button_height];
    button_medium = [UIButton buttonWithType:UIButtonTypeCustom];
    button_medium.frame = rect_temp;
    [button_medium setBackgroundImage:[UIImage imageNamed:@"button_medium.png"]
                                    forState:UIControlStateNormal];
    [button_medium addTarget:self action:@selector(medium) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_medium];
    
    new_button_y = new_button_y + button_height;
    rect_temp =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:button_x yValue:new_button_y width:button_width height:70];
    
    button_hard = [UIButton buttonWithType:UIButtonTypeCustom];
    button_hard.frame = rect_temp;
    [button_hard setBackgroundImage:[UIImage imageNamed:@"button_hard.png"]
                                forState:UIControlStateNormal];
    [button_hard addTarget:self action:@selector(hard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_hard];
    
}
-(void)removeDifficultyButtons{
    [self.gameModelObject playSound:kButtonClick];
    [button_simple removeFromSuperview];
    [button_medium removeFromSuperview];
    [button_hard removeFromSuperview];
    [view_popover removeFromSuperview];
    [self getTimer];
    [self StartTimer];
}
-(void)simple{
    [self removeDifficultyButtons];
    //[GlobalSingleton sharedManager].string_difficulty = @"simple";
    [GlobalSingleton sharedManager].string_difficulty = @"hard";
}
-(void)medium{
    [self removeDifficultyButtons];
    //[GlobalSingleton sharedManager].string_difficulty = @"medium";
    [GlobalSingleton sharedManager].string_difficulty = @"hard";
}
-(void)hard{
    [self removeDifficultyButtons];
    [GlobalSingleton sharedManager].string_difficulty = @"hard";
}
-(UIButton *)getCoinWithPlayer:(UIButton *)button ForPlayer:(NSString *)player{
    NSString *image_player = @"";
    NSArray *all_coins = [self.gameModelObject getArrayOfCoinColors];
    if([player isEqualToString:@"1"]){
        image_player = [all_coins objectAtIndex:[GlobalSingleton sharedManager].int_player_one_coin];
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else if([player isEqualToString:@"2"]){
        image_player = [all_coins objectAtIndex:[GlobalSingleton sharedManager].int_player_two_coin];
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else if([player isEqualToString:@"0"]){
        image_player = @"blank_coin.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else{
        
    }
    if([GlobalSingleton sharedManager].GC){
        if ([GlobalSingleton sharedManager].GC_my_turn &&
            [[GlobalSingleton sharedManager].string_my_turn isEqualToString:player]) {
            [self iAmDraggable:button];
        }
    }
    else if ([[GlobalSingleton sharedManager].string_my_turn isEqualToString:player]) {
        [self iAmDraggable:button];
    }
    return button;
    
}
- (void) iAmDraggable:(UIButton *) button{
    
    [button addTarget:self action:@selector(dragBegan:withEvent: )
     forControlEvents: UIControlEventTouchDown];
    [button addTarget:self action:@selector(dragMoving:withEvent: )
     forControlEvents: UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(dragEnded:withEvent: )
     forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
}
-(void)startSpinnerOnDidLoad{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    CGRect rect_temp =
    CGRectMake([[device_dimensions valueForKey:@"width"] intValue]/2 + 21 ,
               [[device_dimensions valueForKey:@"height"] intValue]/2 + 21,
               100,100);
    spinner = [[UIActivityIndicatorView alloc]initWithFrame:rect_temp];
    spinner.frame = rect_temp;
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner startAnimating];
}
-(void)refreshCapturedBlocks{
    for (int i = 0; i <= 15; i ++) {
        UIImageView *coin_for_player_one =  (UIImageView *)[self.view viewWithTag:i+4000];
        UIImageView *coin_for_player_two =  (UIImageView *)[self.view viewWithTag:i+5000];
        [coin_for_player_one removeFromSuperview];
        [coin_for_player_two removeFromSuperview];
    }
    NSArray *all_coins = [self.gameModelObject getArrayOfCoinColors];
      UIImage *image_player_one = 
   [UIImage imageNamed:[all_coins objectAtIndex:[GlobalSingleton sharedManager].int_player_one_coin]];
    UIImage *image_player_two = 
    [UIImage imageNamed:[all_coins objectAtIndex:[GlobalSingleton sharedManager].int_player_two_coin]];
    for (int i = 0; i <= 15; i ++) {
        if([[[GlobalSingleton sharedManager].array_captured_p1_coins objectAtIndex:i] isEqualToString:@"1"]){
            imageview_captured = [[UIImageView alloc] initWithImage:image_player_one];
            imageview_captured.frame =
            [[[GlobalSingleton sharedManager].array_captured_p1_cgrect objectAtIndex:i] CGRectValue];
            imageview_captured.tag = i + 4000;
            [self.view addSubview:imageview_captured];
           
        }
        if([[[GlobalSingleton sharedManager].array_captured_p2_coins objectAtIndex:i] isEqualToString:@"1"]){
            imageview_captured = [[UIImageView alloc] initWithImage:image_player_two];
            imageview_captured.frame =
            [[[GlobalSingleton sharedManager].array_captured_p2_cgrect objectAtIndex:i] CGRectValue];
            imageview_captured.tag = i + 5000;
            [self.view addSubview:imageview_captured];
        }
    }
    
}
-(void)getAllOptionButtonsForUser{
    UIButton *settings_button = [UIButton buttonWithType:UIButtonTypeCustom];
    settings_button.frame = [cgRectObject settingsButtonCGRect];
    [settings_button setBackgroundImage:[UIImage imageNamed:@"button_settings.png"]
                            forState:UIControlStateNormal];
    [settings_button addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settings_button];
    UIButton *pause_button = [UIButton buttonWithType:UIButtonTypeCustom];
    pause_button.frame = [cgRectObject pauseButtonCGRect];
    [pause_button setBackgroundImage:[UIImage imageNamed:@"button_pause.png"]
                               forState:UIControlStateNormal];
    [pause_button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause_button];
    UIButton *refresh_button = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh_button.frame = [cgRectObject refreshButtonCGRect];
    [refresh_button setBackgroundImage:[UIImage imageNamed:@"button_refresh.png"]
                               forState:UIControlStateNormal];
    [refresh_button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refresh_button];
    UIButton *share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    share_button.frame = [cgRectObject shareButtonCGRect];
    [share_button setBackgroundImage:[UIImage imageNamed:@"button_share.png"]
                               forState:UIControlStateNormal];
    [share_button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share_button];
    UIButton *mainmenu_button = [UIButton buttonWithType:UIButtonTypeCustom];
    mainmenu_button.frame = [cgRectObject mainmenuButtonCGRect];
    [mainmenu_button setBackgroundImage:[UIImage imageNamed:@"button_mainmenu.png"]
                            forState:UIControlStateNormal];
    [mainmenu_button addTarget:self action:@selector(mainmenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainmenu_button];
}
-(void)setPlayerLabels{
    CGRect cgrect_temp = [cgRectObject labelplayerOneTurnCGRect];
    label_player_one = [[UILabel alloc] initWithFrame: cgrect_temp];
    [self.view addSubview:label_player_one];
    cgrect_temp = [cgRectObject labelplayerTwoTurnCGRect];
    label_player_two = [[UILabel alloc] initWithFrame: cgrect_temp];
    [self.view addSubview:label_player_two];
    UIFont *font_digital = [UIFont
                            fontWithName:@"Pump Demi Bold LET"
                            size:[cgRectObject settingFontSize]];
    [label_player_one setFont:font_digital];
    [label_player_two setFont:font_digital];
    label_player_one.textColor = [UIColor whiteColor];
    label_player_two.textColor = [UIColor whiteColor];
    label_player_one.backgroundColor = [UIColor clearColor];
    label_player_two.backgroundColor = [UIColor clearColor];
    label_player_one.text = @"player 1";
    if ([[GlobalSingleton sharedManager].string_opponent isEqualToString:@"computer"]) {
        [label_player_two setText:@"computer"];
    }else{
        label_player_two.text = @"player 2";
    }
    
}
#pragma mark Unused
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}
@end
