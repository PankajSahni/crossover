//
//  AiEngine.m
//  crossover
//
//  Created by Pankaj on 28/03/13.
//
//

#import "AiEngine.h"
#import "GlobalSingleton.h"
#import "PlayerPlacements.h"
#import "ValidMoveDirections.h"
#import "RulesForDoubleJumpvsPlayer.h"
@implementation AiEngine
@synthesize moves;
@synthesize safecapturelist;
@synthesize safemoves;
@synthesize savelist;
@synthesize capturelist;
-(NSMutableDictionary *)playerOne{
    if([self redcount] == 0){
        NSLog(@"computer lost");
    }else{
        array_players_positions = [[NSMutableArray alloc] initWithArray:[GlobalSingleton sharedManager].array_initial_player_positions];
        if([self possiblemoves:2] && [self possiblecaptures:2]
           && [self possiblecapturesOpposition:2] && [self redcount] >0){
            [self checkconditionsforHard:2];
        }
    }
   return [self findMoveByComparingArrays:array_players_positions];
    
    
}
-(NSMutableDictionary *)findMoveByComparingArrays:(NSArray *)array_containing_move{
    NSMutableDictionary *dict_computer_turn = [[NSMutableDictionary alloc] init ];
    for (int i = 0; i <= 48 ; i++) {
        if (![ [array_containing_move objectAtIndex:i] isEqualToString:
              [[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i] ]) {
            if ([[array_containing_move objectAtIndex:i] isEqualToString:@"0"] &&
                [[[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i ] isEqualToString:@"1"]) {
                [dict_computer_turn setObject:[NSString stringWithFormat:@"%d",i] forKey:@"captured"];
            }
            if ([[array_containing_move objectAtIndex:i] isEqualToString:@"0"] &&
                [[[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i ] isEqualToString:@"2"]) {
                [dict_computer_turn setObject:[NSString stringWithFormat:@"%d",i] forKey:@"move"];
            }
            if ([[array_containing_move objectAtIndex:i] isEqualToString:@"2"] &&
                [[[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i ] isEqualToString:@"0"]) {
                [dict_computer_turn setObject:[NSString stringWithFormat:@"%d",i] forKey:@"newposition"];
            }
        }
    }
    return dict_computer_turn;
}
-(void)checkconditionsforHard:(int)playerno{
    safecapturelist = nil;
    safemoves = nil;
    [self safecapturelistHard];
    [self safemoveListlistHard];
    
    if([safecapturelist count]>0){
        
        [self CaptureOppsitionSafe:playerno];
    }/*else if([savelist count]>0 && [self SinglesaveCheckanyChipcanMoveTosave:playerno]){
        //			Log.v("singlemove", "move");
    }*/
    else if([capturelist count]>0){
        
        [self CaptureOppsition:playerno];
    }
    
    else if([safemoves count]>0){
        
        [self SingleMoveSafe:playerno];
    }
    
    else{
        
        [self SingleMove:playerno];
    }
}
-(void)SingleMoveSafe:(int)playerno{
    int index = 0 ;
    if([safemoves count]>1){
        index = arc4random() % [safemoves count];
    }
    NSDictionary *currentpojo = [safemoves objectAtIndex:index];
    
    NSDictionary *futurePojo = [self Movesingle:currentpojo];
    
    int currentPojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                            [[currentpojo objectForKey:@"x"]
                             stringByAppendingString:[currentpojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:currentPojoIndex withObject:@"0"];
    
    int futurePojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                           [[futurePojo objectForKey:@"x"]
                            stringByAppendingString:[futurePojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:futurePojoIndex withObject:[NSString stringWithFormat:@"%d", playerno ]];
    
    
}
-(void)CaptureOppsition:(int)playerno{
    int index = 0 ;
    if([capturelist count]>1){
        index = arc4random() % [capturelist count];
    }
    
    NSDictionary *currentPojo = [capturelist objectAtIndex:index];
    int currentPojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                            [[currentPojo objectForKey:@"x"]
                             stringByAppendingString:[currentPojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:currentPojoIndex withObject:@"0"];
    
    NSDictionary *futurePojo = [self getvaluesforcapture:currentPojo];
    int futurePojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                           [[futurePojo objectForKey:@"x"]
                            stringByAppendingString:[futurePojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:futurePojoIndex withObject:[NSString stringWithFormat:@"%d", playerno ]];
    
    
    NSDictionary *capturedposition = [self getCapturedValues:currentPojo];
    int capturedpositionIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                                 [[capturedposition objectForKey:@"x"]
                                  stringByAppendingString:[capturedposition objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:capturedpositionIndex withObject:@"0"];
}

-(void)SingleMove:(int)playerno{
    int index = 0 ;
    if([moves count]>1){
        index = arc4random() % [moves count];
    }
    NSDictionary *currentPojo = [moves objectAtIndex:index];
    NSDictionary *futurePojo = [self Movesingle:currentPojo];
    
    int currentPojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                            [[currentPojo objectForKey:@"x"]
                             stringByAppendingString:[currentPojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:currentPojoIndex withObject:@"0"];
    
    int futurePojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                           [[futurePojo objectForKey:@"x"]
                            stringByAppendingString:[futurePojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:futurePojoIndex withObject:[NSString stringWithFormat:@"%d", playerno ]];
}
-(NSDictionary *)Movesingle:(NSDictionary *)coin_to_move{
    int index = 0 ;
    NSDictionary *temp = [[NSDictionary alloc] init];
    if([coin_to_move count]>0){
        if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NWU]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
        }
        else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NW]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NWD]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:UP]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:DN]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NEU]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NE]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
        } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:NED]){
            temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                    [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
        }
    }
return temp;
}
-(void)CaptureOppsitionSafe:(int)player{
    int index = 0 ;
    if([safecapturelist count]>1){
        index = arc4random() % [safecapturelist count];
    }
    
    NSDictionary *currentPojo = [safecapturelist objectAtIndex:index];
    int currentPojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
    [[currentPojo objectForKey:@"x"]
     stringByAppendingString:[currentPojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:currentPojoIndex withObject:@"0"];
    
    
    NSDictionary *futurePojo = [self getvaluesforcapture:currentPojo];
    int futurePojoIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                            [[futurePojo objectForKey:@"x"]
                             stringByAppendingString:[futurePojo objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:futurePojoIndex withObject:[NSString stringWithFormat:@"%d", player ]];
    
    
    NSDictionary *capturedposition = [self getCapturedValues:currentPojo];
    int capturedpositionIndex = [[GlobalSingleton sharedManager].array_two_dimensional_board indexOfObject:
                           [[capturedposition objectForKey:@"x"]
                            stringByAppendingString:[capturedposition objectForKey:@"y"]]];
    [array_players_positions replaceObjectAtIndex:capturedpositionIndex withObject:@"0"];
}
-(NSDictionary *)getCapturedValues:(NSDictionary *)coin_to_move{
    NSDictionary *temp;
    int index = 0 ;
    if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNWU]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
    }
    else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNW]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
    }else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNWD]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-1 ],@"y",nil];
    }else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CUP]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
    } else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CDN]){
        
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
        
    }else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNEU]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
    }else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNE]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
    }else     if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNED]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+1 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+1 ],@"y",nil];
    }
    return temp;
}
-(NSDictionary *)getvaluesforcapture:(NSDictionary *)coin_to_move{
    NSDictionary *temp;
    int index = 0;
    if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNWU]){
         temp = [[NSDictionary alloc] initWithObjectsAndKeys:
   [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-2 ],@"x",
[NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-2 ],@"y",nil];
    }
    else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNW]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-2 ],@"y",nil];
    }else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNWD]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+2 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]-2 ],@"y",nil];
    }else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CUP]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-2 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
    }else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CDN]){
        
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+2 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue] ],@"y",nil];
    } else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNEU]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]-2 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+2 ],@"y",nil];
    }else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNE]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue] ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+2 ],@"y",nil];
    }else if([[[coin_to_move objectForKey:@"newpos"] objectAtIndex:index] isEqualToString:CNED]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"x"] intValue]+2 ],@"x",
                [NSString stringWithFormat:@"%d",[[coin_to_move objectForKey:@"y"] intValue]+2 ],@"y",nil];
    } 
    return temp ;
    
}
-(void)safemoveListlistHard{
    safemoves = [[NSMutableArray alloc] init];
    NSMutableArray *array_temp;
    for(int i=0;i<[moves count];i++){
        for(int j =0;j<[[[moves objectAtIndex:i] objectForKey:@"newpos"] count];j++){
            
            NSArray *position =
            [self newPositionMoveHardWithValue:
            (int)[[[[moves objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j] intValue]
                                             forX:(int)[[[moves objectAtIndex:i] objectForKey:@"x"] intValue]
                                             andY:(int)[[[moves objectAtIndex:i] objectForKey:@"y"] intValue]];
            
            
            if([self objectCanbeMovedHardWithI:[[position objectAtIndex:0] intValue]
                                             andJ:[[position objectAtIndex:1] intValue]
                                           Player:2
                                    FromDirection:[[[moves objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j] ]){
                NSString *string_i = [[moves objectAtIndex:i] objectForKey:@"x"];
                NSString *string_j = [[moves objectAtIndex:i] objectForKey:@"y"];
                array_temp = [[NSMutableArray alloc] initWithObjects:[[[moves objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j], nil ];
                NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:string_i,@"x",string_j,@"y",array_temp, @"newpos", nil];
                [safemoves addObject:temp];
                
            }
        }
    }
    
}
-(BOOL)objectCanbeMovedHardWithI:(int)i andJ:(int)j Player:(int)player FromDirection:(NSString *)fromdirection{
    int oppplayer = -1 ;
    if(player==1){
        oppplayer = 2 ;
    }else{
        oppplayer = 1 ;
    }
    
    if((i-1)>=0&&(j-1)>=0 &&(i+1)<=6 &&(j+1)<=6 ){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:NWU])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    if((j-1)>=0 && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:NW])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1] == oppplayer){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6 && (j-1)>=0  && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:NWD])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j]==0 ||
            ([fromdirection isEqualToString:UP])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j] == oppplayer){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j]==0 ||
            ([fromdirection isEqualToString:DN])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j] == oppplayer){
            return false ;
        }
    }
    
    if((i-1)>=0 && (j-1)>=0 &&(i+1)<=6 &&(j+1)<=6 ){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:NEU])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    
    if((j-1)>=0 && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:NE])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1] == oppplayer){
            return false ;
        }
    }
    
    if((i-1)>=0&&(j-1)>=0 &&(i+1)<=6 &&(j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:NED])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    
    return true ;
}
-(NSArray *)newPositionMoveHardWithValue:(int)value forX:(int)x andY:(int)y{
    NSArray *temp;
    if(value == [NWU intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-1 ],
                [NSString stringWithFormat:@"%d",y-1 ], nil];
    }else if(value == [NW intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x ],
                [NSString stringWithFormat:@"%d",y-1 ], nil];
    }else if(value == [NWD intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+1 ],
                [NSString stringWithFormat:@"%d",y-1 ], nil];
    }else if(value == [UP intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-1 ],
                [NSString stringWithFormat:@"%d",y ], nil];
    }else if(value == [DN intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+1 ],
                [NSString stringWithFormat:@"%d",y ], nil];
    }else if(value == [NEU intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-1 ],
                [NSString stringWithFormat:@"%d",y+1 ], nil];
    }else if(value == [NE intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x ],
                [NSString stringWithFormat:@"%d",y+1 ], nil];
    }else if(value == [NED intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+1 ],
                [NSString stringWithFormat:@"%d",y+1 ], nil];
    }
     return temp ;
    
}
-(void)safecapturelistHard{
    NSMutableArray *array_temp;
    safecapturelist = [[NSMutableArray alloc] init];
for(int i=0;i<[capturelist count];i++){
    
    for(int j =0;j<[[[capturelist objectAtIndex:i] objectForKey:@"newpos"] count];j++){
      NSArray *position =
   [self newPositionCaptureHardWithValue:
    (int)[[[[capturelist objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j] intValue]
                forX:(int)[[[capturelist objectAtIndex:i] objectForKey:@"x"] intValue]
                andY:(int)[[[capturelist objectAtIndex:i] objectForKey:@"y"] intValue]];

        if([self objectCanbeCapturedHardWithI:[[position objectAtIndex:0] intValue]
                                      andJ:[[position objectAtIndex:1] intValue]
                                    Player:2
      FromDirection:[[[capturelist objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j] ]){
            NSString *string_i = [[capturelist objectAtIndex:i] objectForKey:@"x"];
            NSString *string_j = [[capturelist objectAtIndex:i] objectForKey:@"y"];
            array_temp = [[NSMutableArray alloc]initWithObjects:[[[capturelist objectAtIndex:i] objectForKey:@"newpos"] objectAtIndex:j], nil];
            NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:string_i,@"x",string_j,@"y",array_temp, @"newpos", nil];
            [safecapturelist addObject:temp];
        }
    }
  }
}
-(BOOL)objectCanbeCapturedHardWithI:(int)i andJ:(int)j Player:(int)player FromDirection:(NSString *)fromdirection{
    int oppplayer = -1 ;
    if(player==1){
        oppplayer = 2 ;
    }else{
        oppplayer = 1 ;
    }
    
    if((i-1)>=0&&(j-1)>=0 &&(i+1)<=6 &&(j+1)<=6 ){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:CNWU])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    if((j-1)>=0 && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:CNW])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1] == oppplayer){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6 && (j-1)>=0  && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1]==0 ||
            ([fromdirection isEqualToString:CNWD])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j]==0 ||
            ([fromdirection isEqualToString:CUP])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j] == oppplayer){
            return false ;
        }
    }
    if((i-1)>=0 && (i+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j]==0 ||
            ([fromdirection isEqualToString:CDN])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j] == oppplayer){
            return false ;
        }
    }
    
    if((i-1)>=0 && (j-1)>=0 &&(i+1)<=6 &&(j+1)<=6 ){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:CNEU])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    
    if((j-1)>=0 && (j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:CNE])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1] == oppplayer){
            return false ;
        }
    }
    
    if((i-1)>=0&&(j-1)>=0 &&(i+1)<=6 &&(j+1)<=6){
        if(([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1]==0 ||
            ([fromdirection isEqualToString:CNWU])) &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1] == oppplayer && [ValidMoveDirections moveDirectionRow:i column:j] ){
            return false ;
        }
    }
    
    return true ;
}
-(NSArray *)newPositionCaptureHardWithValue:(int)value forX:(int)x andY:(int)y{
    NSArray *temp;
    
    if(value == [CNWU intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-2 ],
                [NSString stringWithFormat:@"%d",y-2 ], nil];
    }else if(value == [CNW intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x ],
                [NSString stringWithFormat:@"%d",y-2 ], nil];
    }else if(value == [CNWD intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+2 ],
                [NSString stringWithFormat:@"%d",y-2 ], nil];
    }else if(value == [CUP intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-2 ],
                [NSString stringWithFormat:@"%d",y], nil];
    }else if(value == [CDN intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+2 ],
                [NSString stringWithFormat:@"%d",y ], nil];
    }else if(value == [CNEU intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x-2 ],
                [NSString stringWithFormat:@"%d",y+2 ], nil];
    }else if(value == [CNE intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x ],
                [NSString stringWithFormat:@"%d",y+2 ], nil];
    }else if(value == [CNED intValue]){
        temp = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%d",x+2 ],
                [NSString stringWithFormat:@"%d",y+2 ], nil];
    }
    return temp ;
    
}
-(BOOL)possiblemoves:(int)playerno{
    moves = [[NSMutableArray alloc] init];
    for(int i=0;i<7;i++){
        for(int j=0;j<7;j++){
            
            if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j]==playerno){
                [self checkAllDirectionForMoveForRow:i andColumn:j];
            }
        }
    }
    return true ;
}
-(void)checkAllDirectionForMoveForRow:(int)i andColumn:(int)j{
    BOOL objectadded = false ;
    NSMutableArray *array_temp = [[NSMutableArray alloc]init];
    
    if((i-1)>=0&&(j-1)>=0 ){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1]==0 &&
           [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:NWU];
            objectadded = true ;
        }
    }
    if((j-1)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1]==0){
            [array_temp addObject:NW];
            objectadded = true ;
        }
    }
    if((i+1)<=6&&(j-1)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1]==0 &&
           [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:NWD];
            objectadded = true ;
        }
    }
    if((i-1)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j]==0){
            [array_temp addObject:UP];
            objectadded = true ;
        }
    }
    if((i+1)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j]==0){
            [array_temp addObject:DN];
            objectadded = true ;
        }
    }
    
    if((i-1)>=0 &&(j+1)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1]==0 &&
           [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:NEU];
            objectadded = true ;
        }
    }
    
    if((j+1)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1]==0){
            [array_temp addObject:NE];
            objectadded = true ;
        }
    }
    
    if((i+1)<=6 &&(j+1)<=6 ){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1]==0 &&
           [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:NED];
            objectadded = true ;
        }
    }
    
    if(objectadded){
        NSString *string_i = [NSString stringWithFormat:@"%d",i];
        NSString *string_j = [NSString stringWithFormat:@"%d",j];
        NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:string_i,@"x",string_j,@"y",array_temp, @"newpos", nil];
        [moves addObject:temp];
    }
    
}
-(BOOL)possiblecaptures:(int)playerno{
    capturelist = [[NSMutableArray alloc] init];
    for(int i=0;i<7;i++){
        for(int j=0;j<7;j++){
          
            
            if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j]==playerno){
                [self checkAllDirectionCaptureForRow:i andColumn:j ForPlayer:playerno];
                
            }
        }
    }
    return true ;
}
-(void)checkAllDirectionCaptureForRow:(int)i andColumn:(int)j ForPlayer:(int)player{
    int oppplayer = -1 ;
    if(player==1){
        oppplayer = 2 ;
    }else{
        oppplayer = 1 ;
    }
    
    BOOL objectcanCapture = false ;
    NSMutableArray *array_temp = [[NSMutableArray alloc]init];
    if((i-2)>=0&&(j-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i-2 endY:j-2] && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNWU];
            objectcanCapture = true ;
        }
    }
    if((j-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i endY:j-2] ){
            [array_temp addObject:CNW];
            objectcanCapture = true ;
        }
    }
    if( (i+2)<=6 && (j-2)>=0 ){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+2 AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i+2 endY:j-2] && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNWD];
            objectcanCapture = true ;
        }
    }
    if((i-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i-2 endY:j] ){
            [array_temp addObject:CUP];
            objectcanCapture = true ;
        }
    }
    if((i+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+2 AndCoumn:j]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i+2 endY:j] ){
            [array_temp addObject:CDN];
            objectcanCapture = true ;
        }
    }
    
    if((i-2)>=0 &&(j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j+2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i-2 endY:j+2]  && [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:CNEU];
            objectcanCapture = true ;
        }
    }
    
    if((j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i endY:j+2] ){
            [array_temp addObject:CNE];
            objectcanCapture = true ;
        }
    }
    
    if((i+2)<=6 &&(j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+2 AndCoumn:j+2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1] == oppplayer && [RulesForDoubleJumpvsPlayer invalidPointsListForCaptureStartX:i StartY:j endX:i+2 endY:j+2]  && [ValidMoveDirections moveDirectionRow:i column:j]){
            [array_temp addObject:CNED];
            objectcanCapture = true ;
        }
    }
    if (i==3 && j==2) {
        
    }
    
    if(objectcanCapture){
        NSString *string_i = [NSString stringWithFormat:@"%d",i];
        NSString *string_j = [NSString stringWithFormat:@"%d",j];
        NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:string_i,@"x",string_j,@"y",array_temp, @"newpos", nil];
        //
        [capturelist addObject:temp];
        //NSLog(@"capturelist %@",capturelist);
        
    }
    
}
-(void)checkAllDirectionCaptureOppositionForRow:(int)i andColumn:(int)j ForPlayer:(int)player{
    int oppplayer = -1 ;
    if(player==1){
        oppplayer = 2 ;
    }else{
        oppplayer = 1 ;
    }
    
    BOOL objectcanCapture = false ;
    NSMutableArray *array_temp = [[NSMutableArray alloc]init];
    if((i-2)>=0&&(j-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j-1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNWU];
            objectcanCapture = true ;
        }
    }
    if((j-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j-1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNW];
            objectcanCapture = true ;
        }
    }
    if( (i+2)<=6 && (j-2)>=0 ){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+2 AndCoumn:j-2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j-1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNWD];
            objectcanCapture = true ;
        }
    }
    if((i-2)>=0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CUP];
            objectcanCapture = true ;
        }
    }
    if((i+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+2 AndCoumn:j]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CDN];
            objectcanCapture = true ;
        }
    }
    
    if((i-2)>=0 &&(j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i-2 AndCoumn:j+2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i-1 AndCoumn:j+1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNEU];
            objectcanCapture = true ;
        }
    }
    
    if((j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+2]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j+1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            //[array_temp addObject:CNE];
            objectcanCapture = true ;
        }
    }
    
    if((i+2)<=6 &&(j+2)<=6){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1]==0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:i+1 AndCoumn:j+1] == player && [ValidMoveDirections moveDirectionRow:i column:j] ){
            [array_temp addObject:CNED];
            objectcanCapture = true ;
        }
    }
    
    if(objectcanCapture){
        NSString *string_i = [NSString stringWithFormat:@"%d",i];
        NSString *string_j = [NSString stringWithFormat:@"%d",j];
        NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:string_i,@"x",string_j,@"y",array_temp, @"newpos", nil];
        [savelist addObject:temp];
    }
}
-(BOOL)possiblecapturesOpposition:(int)playerno{
    savelist = [[NSMutableArray alloc] init];
    int oppplayer = -1 ;
    for(int i=0;i<7;i++){
        for(int j=0;j<7;j++){
            
            
            if(playerno == 1){
                oppplayer = 2 ;
            }else{
                oppplayer = 1 ;
            }
            if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j]==oppplayer ){
        [self checkAllDirectionCaptureOppositionForRow:i andColumn:j ForPlayer:playerno];
            }
        }
    }
    return true ;
}
-(int)redcount{
    int count = 0;
    for (int i = 0; i <= 48 ; i++) {
        if([[[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i ] isEqualToString:@"2"]){
            count ++;
        }
    }
           return count;
}
@end
