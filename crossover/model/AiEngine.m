//
//  AiEngine.m
//  crossover
//
//  Created by Pankaj on 28/03/13.
//
//

#import "AiEngine.h"
#import "GlobalSingleton.h"
@implementation AiEngine

-(void)playerOne{
    if([self redcount] == 0){
        NSLog(@"computer lost");
    }else{
        if([self possiblemoves:2] && [self possiblecaptures:2]
           && [self possiblecapturesOpposition:2] && [self redcount] >0){
            
        }
    }
}

-(BOOL)possiblemoves:(int)playerno{
    for(int i=0;i<7;i++){
        for(int j=0;j<7;j++){
//            /MovePojo pojo =new MovePojo() ;
            if([[GlobalSingleton sharedManager] getCellStatusWithRow:i AndCoumn:j]==playerno){
                checkAllDirectionForMove(i, j, list, pojo);
            }
        }
    }
    return true ;
    return true;
}
-(BOOL)possiblecaptures:(int)player{
    return true;
}
-(BOOL)possiblecapturesOpposition:(int)player{
    return true;
}
-(int)redcount{
    int count = 0;
    for (int i = 0; i <= 48 ; i++) {
        if([[[GlobalSingleton sharedManager].array_initial_player_positions objectAtIndex:i] isEqualToString:@"2"]){
            count ++;
        }
    }
           return count;
}
@end
