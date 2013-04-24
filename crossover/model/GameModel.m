//
//  GameModel.m
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import "GameModel.h"
#import "GlobalSingleton.h"
#import "RulesForSingleJumpVsPalyer.h"
#import "RulesForDoubleJumpvsPlayer.h"
#import "AiEngine.h"
#import "GCHelper.h"
#import "MyEnums.h"
#import <AudioToolbox/AudioToolbox.h>
@interface GameModel ()
@property (readonly) AiEngine *aiEngineObject;
@end
@implementation GameModel

@synthesize dictionary_my_device_dimensions;
@synthesize delegate_game_model;
@synthesize isPlayer1;
@synthesize audio_player;
@synthesize less_time_left;
//@synthesize delegate_refresh_my_data;
- (AiEngine *) aiEngineObject{
    if(!aiEngineObject){
        aiEngineObject = [[AiEngine alloc] init];
    }
    return aiEngineObject;
}
/*- (id)init {
    if ((self = [super init])) {
        if ([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"] ||
            [[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]) {
           iPhoneCGRect *cgRectObject = [[iPhoneCGRect alloc] init];
        }else{
            iPadCGRect *cgRectObject = [[iPadCGRect alloc] init];
        }
        
    }
    return self;
}*/


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
    int int_x = 52;
    int int_y = 170;
    [GlobalSingleton sharedManager].array_two_dimensional_board = 
    [[NSMutableArray alloc ] init ];
    
    for (int i = 0; i <= 6; i ++) {
        
        for (int j = 0; j <= 6; j++) {
            NSString *string_dict_keys =  [[NSString stringWithFormat:@"%d", j]stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
            [[GlobalSingleton sharedManager].array_two_dimensional_board addObject:string_dict_keys];
            
            
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
        int_x = 52;
    }
    return array_temp;
}

-(void)setCoinColors{
    if (![GlobalSingleton sharedManager].int_player_one_coin && ![GlobalSingleton sharedManager].int_player_two_coin) {
        [GlobalSingleton sharedManager].int_player_one_coin = 0;
        [GlobalSingleton sharedManager].int_player_two_coin = 1;
    }
}
-(int)validateMoveWithEndPoint:(CGPoint)end_point WithCoinPicked:(int)tag_coin_picked{
    int int_array_index = 0;
    int coin_eliminated = 0;
    if ([GlobalSingleton sharedManager].GC) {
        [GlobalSingleton sharedManager].int_GC_captured = 0;
        [GlobalSingleton sharedManager].int_GC_move = 0;
        [GlobalSingleton sharedManager].int_GC_newposition = 0;
    }
    
    for (NSValue *cgrect_loop in [GlobalSingleton sharedManager].array_all_cgrect) {
        
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
                [self playSound:kMove];
                if ([GlobalSingleton sharedManager].GC) {
                    [GlobalSingleton sharedManager].GC_my_turn = FALSE;
                    [delegate_game_model changeMyTurnLabelMessage:FALSE];
                    [GlobalSingleton sharedManager].int_GC_move = tag_coin_picked;
                    [GlobalSingleton sharedManager].int_GC_newposition = int_array_index;
                    [self sendMove];
                }
                if (![GlobalSingleton sharedManager].GC) {
                    [self togglePlayer];
                }
            
            }
            if(
                     ( ( abs(diff_row)==0 && abs(diff_col) == 2) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==0) ||
                      ( abs(diff_row)==2 && abs(diff_col) ==2) )
                     && ([RulesForDoubleJumpvsPlayer captureRuleStartX:start_x StartY:start_y endX:end_x endY:end_y])){
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:tag_coin_picked withObject:@"0"];
                [[GlobalSingleton sharedManager].array_initial_player_positions
                 replaceObjectAtIndex:int_array_index withObject:[GlobalSingleton sharedManager].string_my_turn];
                coin_eliminated = end_x +(diff_row/2)+ (7*(end_y +(diff_col/2)));
                if ([GlobalSingleton sharedManager].GC) {
                    [GlobalSingleton sharedManager].GC_my_turn = FALSE;
                    [delegate_game_model changeMyTurnLabelMessage:FALSE];
                    [GlobalSingleton sharedManager].int_GC_captured = coin_eliminated;
                    [GlobalSingleton sharedManager].int_GC_move = tag_coin_picked;
                    [GlobalSingleton sharedManager].int_GC_newposition = int_array_index;
                    [self sendMove];
                } 
			}
            
            
        }
        int_array_index ++ ;
    }
    return coin_eliminated;
}

-(void) togglePlayer{
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]){
        [GlobalSingleton sharedManager].string_my_turn = @"2";
    }else{
        [GlobalSingleton sharedManager].string_my_turn = @"1";
    }
}

- (void)matchStarted {
    NSLog(@"Match started");
    [delegate_game_model addLabelToShowMultiplayerGameStatus];
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
    
}
-(void)addCoinToCaptureBlockWithIndex:(int)index ForPlayer:(NSString *)player_at_position{
    //NSLog(@"turn %@",[GlobalSingleton sharedManager].string_my_turn);
    if([player_at_position isEqualToString:@"2"]){
        for (int i = 0; i <= 15; i++) {
            if ([[[GlobalSingleton sharedManager].array_captured_p2_coins objectAtIndex:i] isEqualToString:@"0"]) {
                [[GlobalSingleton sharedManager].array_captured_p2_coins replaceObjectAtIndex:i withObject:@"1"];
                break;
            }
        }
    }
    else{
        for (int i = 0; i <= 15; i++) {
            if ([[[GlobalSingleton sharedManager].array_captured_p1_coins objectAtIndex:i] isEqualToString:@"0"]) {
                [[GlobalSingleton sharedManager].array_captured_p1_coins replaceObjectAtIndex:i withObject:@"1"];
                break;
            }
        }
    }
}

-(void)findMatchWithViewController:(UIViewController *)viewController{
    [GCHelper sharedInstance].delegate = self;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:viewController delegate:self];
    ourRandom = arc4random();
    [self setGameState:kGameStateWaitingForMatch];
}
-(NSMutableDictionary *)updateTimerForPlayer{
    [self timerSound];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    NSString *string_player_one_time = @"";
    NSString *string_player_two_time = @"";
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"1"]){
        if ([GlobalSingleton sharedManager].int_seconds_p1 == 00)
        {
            [GlobalSingleton sharedManager].int_seconds_p1 = 60;
            [GlobalSingleton sharedManager].int_minutes_p1 --;
        }
        
        [GlobalSingleton sharedManager].int_seconds_p1 --;
    }
    string_player_one_time = [NSString stringWithFormat:@"%02d:%02d",
                              [GlobalSingleton sharedManager].int_minutes_p1,
                              [GlobalSingleton sharedManager].int_seconds_p1];
    if ([string_player_one_time isEqualToString:@"01:00"]) {
        less_time_left = TRUE;
    }
    [self checkIfTimeIsOver:string_player_one_time];
    [temp setObject:string_player_one_time forKey:@"player_one"];
    
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"] ||
       [[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"computer"]){
        if ([GlobalSingleton sharedManager].int_seconds_p2 == 00)
        {
            [GlobalSingleton sharedManager].int_seconds_p2 = 60;
            [GlobalSingleton sharedManager].int_minutes_p2 --;
        }
        
        [GlobalSingleton sharedManager].int_seconds_p2 --;
         
    }
    string_player_two_time = [NSString stringWithFormat:@"%02d:%02d",
                              [GlobalSingleton sharedManager].int_minutes_p2,
                              [GlobalSingleton sharedManager].int_seconds_p2];
    if ([string_player_two_time isEqualToString:@"01:00"]) {
        less_time_left = TRUE;
    }
    [self checkIfTimeIsOver:string_player_two_time];
    [temp setObject:string_player_two_time forKey:@"player_two"];
    return temp;
}
-(void)timerSound{
    if (less_time_left) {
        [self playTimerSound:kTickTockFast];
    }else{
        [self playTimerSound:kTickNormal];
    }
    
}
-(void)checkIfTimeIsOver:(NSString *)time_now{
    if ([time_now isEqualToString:@"00:00"]) {
        int winner = [self timeOverShowWinner];
        if (winner) {
            [delegate_game_model showWinner:(int)winner];
        }else{
            [delegate_game_model showWinner:(int)0];
        }
    }
}
-(NSDictionary *)computerTurn{
    
   NSDictionary *dict_computer_turn = [self.aiEngineObject playerOne];
    return dict_computer_turn;
}

-(int)anybodyWon{
    BOOL p1_coin_exist = FALSE;
    BOOL p2_coin_exist = FALSE;
    for (int i = 0; i <= 48; i++) {
        NSString *player =
        [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i];
        if ([player isEqualToString:@"1"]) {
            p1_coin_exist = TRUE;
        }
        if ([player isEqualToString:@"2"]) {
            p2_coin_exist = TRUE;
        }
    }
    if (p1_coin_exist == FALSE) {
        return 2;
    }
    else if (p2_coin_exist == FALSE) {
        return 1;
    }
    else{
        return 0;
    }
}
-(int)timeOverShowWinner{
    int p1 = 0;
    int p2 = 0;
    int return_winner = 0;
    for (int i = 0; i <= 48; i++) {
        NSString *player =
        [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i];
        if ([player isEqualToString:@"1"]) {
            p1 ++;
        }
        if ([player isEqualToString:@"2"]) {
            p2 ++;
        }
    }
    if (p1==0 && p2==0) {
        return_winner = 0;
    }
    else if (p1 > p2) {
        return_winner = 1;
    }
    else if(p1 < p2){
        return_winner = 2;
    }else{
        return_winner = 0;
    }
    return return_winner;
}
- (void)inviteReceived {
    //[self restartTapped:nil];
}
-(void)resetGame{
   
     [GlobalSingleton sharedManager].array_initial_player_positions = nil;
     [GlobalSingleton sharedManager].array_captured_p1_coins = nil;
     [GlobalSingleton sharedManager].array_captured_p2_coins = nil;
     [GlobalSingleton sharedManager].int_minutes_p1 = 2;
     [GlobalSingleton sharedManager].int_minutes_p2 = 2;
     [GlobalSingleton sharedManager].int_seconds_p1 = 0;
     [GlobalSingleton sharedManager].int_seconds_p2 = 0;
}
#pragma mark GCHelperDelegate
- (void)tryStartGame {
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        [self setGameState:kGameStateActive];
        if ([GlobalSingleton sharedManager].GC) {
            if ([GlobalSingleton sharedManager].GC_my_turn) {
                [delegate_game_model changeMyTurnLabelMessage:TRUE];
            }else{
                [delegate_game_model changeMyTurnLabelMessage:FALSE];
            }
        }
        [self sendGameBegin];
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
- (void)matchEnded {
    NSLog(@"Match ended");
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
    message.move = [GlobalSingleton sharedManager].int_GC_move;
    message.captured = [GlobalSingleton sharedManager].int_GC_captured;
    message.newposition = [GlobalSingleton sharedManager].int_GC_newposition;
    
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
- (void)setGameState:(GameState)state {
    
    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        [delegate_game_model initialSetUpMessagesForLabel:@"Waiting for match"];
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        [delegate_game_model initialSetUpMessagesForLabel:@"Waiting for match"];
    } else if (gameState == kGameStateWaitingForStart) {
        [delegate_game_model initialSetUpMessagesForLabel:@"Waiting for match"];
    } else if (gameState == kGameStateActive) {
        [delegate_game_model initialSetUpMessagesForLabel:@"Waiting for match"];
    } else if (gameState == kGameStateDone) {
        [delegate_game_model initialSetUpMessagesForLabel:@"Waiting for match"];
    }
    
}
- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

-(void)foundPlayer{
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
}
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = playerID;
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        NSLog(@"Received random number: %ud, ours %ud", messageInit->randomNumber,ourRandom);
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
            [delegate_game_model changeMyTurnLabelMessage:TRUE];
            [GlobalSingleton sharedManager].string_my_turn = @"1";
        } else {
            NSLog(@"We are player 2");
            isPlayer1 = NO;
            [GlobalSingleton sharedManager].GC_my_turn = FALSE;
            [delegate_game_model changeMyTurnLabelMessage:FALSE];
            
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
        [delegate_game_model getBoard];
        //[self setupStringsWithOtherPlayerId:playerID];
        
    } else if (message->messageType == kMessageTypeMove) {
        
        
        MessageMove *messageTypeMove = (MessageMove *) [data bytes];
        
        
        NSLog(@"newposition %d",messageTypeMove->newposition);
        NSLog(@"move %d",messageTypeMove->move);
        NSLog(@"captured %d",messageTypeMove->captured);
        
        NSDictionary *received_dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [NSString stringWithFormat:@"%d", messageTypeMove->newposition ],@"newposition",
                                             [NSString stringWithFormat:@"%d", messageTypeMove->move ],@"move",
                                             [NSString stringWithFormat:@"%d", messageTypeMove->captured ],@"captured",nil];
        
        [delegate_game_model animateComputerOrGameCenterMove:received_dictionary];
        
        [GlobalSingleton sharedManager].GC_my_turn = TRUE;
        [delegate_game_model changeMyTurnLabelMessage:TRUE];
        //[self getBoard];
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
-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel{
    int x = pixel;
    int y = pixel;
    int local_width = width - 2*pixel;
    int local_height = height - 2*pixel;
    CGRect rect_local = CGRectMake(x, y, local_width, local_height);
    return rect_local;
    
}
-(NSArray *)getArrayOfCoinColors{
    NSArray *temp = [[NSArray alloc] initWithObjects:
    @"i1.png",@"i2.png", @"i3.png", @"i4.png", @"i5.png", @"i6.png", @"i7.png", @"i8.png", @"i9.png", @"i10.png",
                     @"i11.png", @"i12.png", @"i13.png", @"i14.png", @"i15.png", @"i16.png", @"i17.png", nil];
    return temp;
}

-(void)playTimerSound:(PlaySound)play_sound{
    if ([GlobalSingleton sharedManager].bool_sound) {
        NSString *sound_file_path = @"";
        switch (play_sound) {
                break;
            case kTickNormal:{
                sound_file_path  = [[NSBundle mainBundle] pathForResource:@"ticknormal" ofType:@"mp3"];
            }
                break;
            case kTickTockFast:{
                sound_file_path  = [[NSBundle mainBundle] pathForResource:@"ticktockfast" ofType:@"wav"];
            }
                break;
            default:
                break;
        }
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: sound_file_path], &soundID);        
        AudioServicesPlaySystemSound (soundID);
    }
}
-(void)playSound:(PlaySound)play_sound{
    if ([GlobalSingleton sharedManager].bool_sound) {
    NSString *sound_file_path = @"";
    switch (play_sound) {
        case kCapture:{
          sound_file_path  = [[NSBundle mainBundle] pathForResource:@"capture" ofType:@"wav"];
        }
            break;
        case kButtonClick:{
            sound_file_path  = [[NSBundle mainBundle] pathForResource:@"buttonclick" ofType:@"wav"];
        }
            break;
        case kApplause:{
            sound_file_path  = [[NSBundle mainBundle] pathForResource:@"applause" ofType:@"mp3"];
        }
            break;
        case kMove:{
            sound_file_path  = [[NSBundle mainBundle] pathForResource:@"move" ofType:@"mp3"];
        }
            break;
        default:
            break;
    }
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:sound_file_path];
    audio_player =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
    [audio_player play];
    }
}


@end
