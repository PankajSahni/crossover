//
//  RulesForDoubleJumpvsPlayer.m
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import "RulesForDoubleJumpvsPlayer.h"
#import "GlobalSingleton.h"
#import "ValidMoveDirections.h"
@implementation RulesForDoubleJumpvsPlayer
+ (BOOL)captureRuleStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    return [self checkAllDirectionCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy]
    && [self invalidPointsListForCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy];
}

+ (BOOL)checkAllDirectionCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    int oppplayer = -1 ;
    if([[GlobalSingleton sharedManager].string_my_turn isEqualToString:@"2"]){
        oppplayer = 1 ;
    }else{
        oppplayer = 2 ;
    }
    
    
    if((startx-2)>=0 && (starty-2)>=0&&(startx-endx)==2&&(starty-endy)==2){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-2 AndCoumn:(int)starty-2] == 0 &&
           [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-1 AndCoumn:(int)starty-1] == oppplayer &&
           [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    
    if((starty-2)>=0 &&(startx-endx)==0  && (starty-endy)==2 ){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty-2]==0&& [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty-1]==oppplayer){
            return true ;
        }
    }
    if( (startx+2)<=6 && (starty-2)>=0 && (startx-endx)==-2 && (starty-endy)==2){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+2 AndCoumn:(int)starty-2]==0 && [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty-1]==oppplayer &&
           [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    if((startx-2)>=0  && (startx-endx) == 2 && (starty-endy) == 0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-2 AndCoumn:(int)starty]==0&&[[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-1 AndCoumn:(int)starty]==oppplayer){
            return true ;
        }
    }
    if((startx+2)<=6 && (startx-endx) == -2 && (starty-endy) == 0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+2 AndCoumn:(int)starty] == 0 && [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty]==oppplayer){
            return true ;
        }
    }
    
    if((startx-2)>=0 &&(starty+2)<=6 && (startx-endx) == 2 && (starty-endy) == -2){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-2 AndCoumn:(int)starty+2]==0 && [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-1 AndCoumn:(int)starty+1]==oppplayer &&
           [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    
    if((starty+2)<=6 && (startx-endx) == 0 && (starty-endy) == -2){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty+2]==0 && [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty+1]==oppplayer){
            return true ;
        }
    }
    
    if((startx+2)<=6 &&(starty+2)<=6 && (startx-endx) == -2 && (starty-endy) == -2){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+2 AndCoumn:(int)starty+2]==0 && [[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty+1]==oppplayer &&
           [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    return false ;
}

+ (BOOL)invalidPointsListForCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    if(startx==0 & starty==3 && endx == 2 && endy == 1){
        return false ;
    }
    else if(startx==2 & starty==1 && endx == 0 && endy == 3){
        return false ;
    }
    
    else if(startx==4 & starty==1 && endx == 6 && endy == 3){
        return false ;
    }else if(startx==6 & starty==3 && endx == 4 && endy == 1){
        return false ;
    }
    
    else if(startx==6 & starty==3 && endx == 4 && endy == 5){
        return false ;
    }else if(startx==4 & starty==5 && endx == 6 && endy == 3){
        return false ;
    }
    
    else if(startx==2 & starty==5 && endx == 0 && endy == 3){
        return false ;
    }else if(startx==0 & starty==3 && endx == 2 && endy == 5){
        return false ;
    }
    
    return true ;
}
@end
