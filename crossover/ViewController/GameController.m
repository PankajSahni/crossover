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
#import "GCHelper.h"
#import "AppDelegate.h"
@interface GameController ()
@property (readonly) GameModel *gameModelObject;
@property (readonly) BoardUIView *boardModelObject;
@end

@implementation GameController

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
- (void)setGameState:(GameState)state {
    
    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        [debugLabel setText:@"Waiting for match"];
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        [debugLabel setText:@"Waiting for rand #"];
    } else if (gameState == kGameStateWaitingForStart) {
        [debugLabel setText:@"Waiting for start"];
    } else if (gameState == kGameStateActive) {
        [debugLabel setText:@"Active"];
    } else if (gameState == kGameStateDone) {
        [debugLabel setText:@"Done"];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self.view addSubview:self.boardModelObject];
    [self getBoard];
    
    [self getPopOverToStartGame];
    //[self performSelector:@selector(GCFindMatch) withObject:nil afterDelay:0];
   
    
}
- (void)inviteReceived {
    //[self restartTapped:nil];
}
-(void)GCFindMatch{
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.viewController delegate:self];
    ourRandom = arc4random();
    [self setGameState:kGameStateWaitingForMatch];
}
#pragma mark GCHelperDelegate
- (void)tryStartGame {
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        [self setGameState:kGameStateActive];
        [self sendGameBegin];
        //[self setupStringsWithOtherPlayerId:otherPlayerID];
    }
    
}
- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
    
}

- (void)sendMove {
    
    MessageMove message;
    message.message.messageType = kMessageTypeMove;
    message.player_positions =
    [GlobalSingleton sharedManager].array_initial_player_positions;
    //NSLog(@"move messgae %@",message.player_positions);
    
    
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendData:data];
    
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
    
}
- (void)matchStarted {
    NSLog(@"Match started");
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
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
}
- (void)matchEnded {
    NSLog(@"Match ended");
}
-(void)playerVsGameCenter{
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
                         [GCHelper sharedInstance].delegate = self;
                         [[GCHelper sharedInstance] authenticateLocalUser];
                         [self performSelector:@selector(GCFindMatch) withObject:nil afterDelay:1.0];
                         [GlobalSingleton sharedManager].GC = TRUE;
                         
                     }];
	[UIView commitAnimations];
    
}
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = playerID;
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        NSLog(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
        bool tie = false;
        
        if (messageInit->randomNumber == ourRandom) {
            NSLog(@"TIE!");
            tie = true;
            ourRandom = arc4random();
            [self sendRandomNumber];
        } else if (ourRandom > messageInit->randomNumber) {
            NSLog(@"We are player 1");
            isPlayer1 = YES;
            [GlobalSingleton sharedManager].GC_my_turn = TRUE;
            [GlobalSingleton sharedManager].string_my_turn = @"1";
        } else {
            NSLog(@"We are player 2");
            isPlayer1 = NO;
            [GlobalSingleton sharedManager].GC_my_turn = FALSE;
            [GlobalSingleton sharedManager].string_my_turn = @"2";
        }
        
        if (!tie) {
            receivedRandom = YES;
            if (gameState == kGameStateWaitingForRandomNumber) {
                [self setGameState:kGameStateWaitingForStart];
            }
            [self tryStartGame];
        }
        
    } else if (message->messageType == kMessageTypeGameBegin) {
        
        [self setGameState:kGameStateActive];
        //[self setupStringsWithOtherPlayerId:playerID];
        
    } else if (message->messageType == kMessageTypeMove) {
        
        
        MessageMove *messageTypeMove = (MessageMove *) [data bytes];
        
        
        NSLog(@"received_array %@",messageTypeMove->player_positions);
        
        NSArray *received_array = [[NSArray alloc] initWithArray: messageTypeMove->player_positions];
        
        
        [self animateComputerOrGameCenterMove:
         [self.gameModelObject updatePlayerPostions:received_array]];
        
        [GlobalSingleton sharedManager].GC_my_turn = TRUE;
        [self getBoard];
        
        NSLog(@"Received move %@",received_array);
        /*
        if (isPlayer1) {
            [player2 moveForward];
        } else {
            [player1 moveForward];
        }*/
    } else if (message->messageType == kMessageTypeGameOver) {
        
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        NSLog(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
        
        if (messageGameOver->player1Won) {
             NSLog(@"pankaj kEndReasonLose");
            //[self endScene:kEndReasonLose];
        } else {
            //[self endScene:kEndReasonWin];
            NSLog(@"pankaj kEndReasonWin");
        }
        
    }
}
-(UIButton *)getCoinWithPlayer:(UIButton *)button ForPlayer:(NSString *)player{
    NSString *image_player = @"";
    if([player isEqualToString:@"1"]){
        image_player = [self.gameModelObject string_player_one_coin];
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else if([player isEqualToString:@"2"]){
        image_player = [self.gameModelObject string_player_two_coin];
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
    if([GlobalSingleton sharedManager].GC){
        if ([GlobalSingleton sharedManager].GC_my_turn) {
            [self iAmDraggable:button];
        }
    }
    else if ([[GlobalSingleton sharedManager].string_my_turn isEqualToString:player]) {
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
    if ([GlobalSingleton sharedManager].GC) {
        [GlobalSingleton sharedManager].GC_my_turn = FALSE;
        [self getBoard];
        [self sendMove];
    }
    
    //
}
-(void)animateEliminatedCapturedCoinWithIndex:(int)captured{
    
    CGRect move_to;
    NSString *player_at_position = [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:captured];
    //NSLog(@"player_at_position %@",player_at_position);
    
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
    [self.gameModelObject addCoinToCaptureBlockWithIndex:captured];
    if (![GlobalSingleton sharedManager].GC) {
        [self.gameModelObject togglePlayer];
    }
    [self getBoard];
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
        if (isPlayer1) {
            opposite_player = @"2";
        }else{
            opposite_player = @"1";
        }
    }else{
         opposite_player = @"2";
    }
    
    CGRect move_to = [[[GlobalSingleton sharedManager].array_all_cgrect objectAtIndex:newposition] CGRectValue];
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

-(void)refreshCapturedBlocks{
    UIImage *image_player_one = [UIImage imageNamed:[self.gameModelObject string_player_one_coin]];
    UIImage *image_player_two = [UIImage imageNamed:[self.gameModelObject string_player_two_coin]];
    for (int i = 0; i <= 15; i ++) {
        if([[[GlobalSingleton sharedManager].array_captured_p1_coins objectAtIndex:i] isEqualToString:@"1"]){
            UIImageView *imageview_temp = [[UIImageView alloc] initWithImage:image_player_one];
            imageview_temp.frame =
            [[[GlobalSingleton sharedManager].array_captured_p1_cgrect objectAtIndex:i] CGRectValue];
            [self.view addSubview:imageview_temp];
        }
        if([[[GlobalSingleton sharedManager].array_captured_p2_coins objectAtIndex:i] isEqualToString:@"1"]){
            UIImageView *imageview_temp = [[UIImageView alloc] initWithImage:image_player_two];
            imageview_temp.frame =
            [[[GlobalSingleton sharedManager].array_captured_p2_cgrect objectAtIndex:i] CGRectValue];
            [self.view addSubview:imageview_temp];
        }
    }
    
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
}
-(void)showWinner:(int)winner{
    ShowWinnerViewController *showWinner = [[ShowWinnerViewController alloc] init];
    showWinner.winner = winner;
    [self presentModalViewController:showWinner animated:YES];
}
-(void)share{
    NSLog(@"share");
    
}
-(void)playerVsPlayer{
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
                     }];
	[UIView commitAnimations];
    
}
-(void)playerVsComputer{
    
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
                     }];
	[UIView commitAnimations];
    [GlobalSingleton sharedManager].string_opponent = @"computer";
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick
{
    
    NSString *string_time_now = [[self gameModelObject] updateTimerForPlayer];
    if ([string_time_now isEqualToString:@"00:00"]) {
        [timer invalidate];
        int winner = [self.gameModelObject timeOverShowWinner];
        if (winner) {
            [self showWinner:(int)winner];
        }else{
            [self showWinner:(int)0];
        }
    }
    if ([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]) {
       time_label_P1.text= string_time_now;
    }else{
        time_label_P2.text= string_time_now;
    }
    
    
}

-(void)getTimer{
    [GlobalSingleton sharedManager].int_minutes_p1 = 2;
    [GlobalSingleton sharedManager].int_seconds_p1 = 0;
    [GlobalSingleton sharedManager].int_minutes_p2 = 2;
    [GlobalSingleton sharedManager].int_seconds_p2 = 0;
    
    CGRect rect_temp =
    [[GlobalSingleton sharedManager]
     getFrameAccordingToDeviceWithXvalue:705 yValue:565 width:70 height:35];
    time_label_P1 = [[UILabel alloc] initWithFrame: rect_temp];
    time_label_P1.frame = rect_temp;
    [self.view addSubview:time_label_P1];
    UIFont *font_digital = [UIFont
                            fontWithName:@"Let's go Digital"
                            size:12];
    [time_label_P1 setFont:font_digital];
    time_label_P1.textColor = [UIColor whiteColor];
    time_label_P1.backgroundColor = [UIColor clearColor];
    time_label_P1.text = @"02:00";
    
    rect_temp =
    [[GlobalSingleton sharedManager]
     getFrameAccordingToDeviceWithXvalue:910 yValue:255 width:70 height:35];
    time_label_P2 = [[UILabel alloc] initWithFrame: rect_temp];
    time_label_P2.frame = rect_temp;
    time_label_P2.textColor = [UIColor whiteColor];
    time_label_P2.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:time_label_P2];
    [time_label_P2 setFont:font_digital];
    time_label_P2.text = @"02:00";
    [self StartTimer];
}
-(void) getBoard{
    tag_coin_picked = 0;
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
    [GlobalSingleton sharedManager].array_all_cgrect = [[NSMutableArray alloc] init];
    int array_position = 0;
    for (NSDictionary *dict_x_y in board_dimensions) {
        CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:[[dict_x_y valueForKey:@"x"] intValue]
                                                                                           yValue:[[dict_x_y valueForKey:@"y"] intValue]
                                                                                            width:40 height:40];
        
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
@end
