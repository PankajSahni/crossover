//
//  RulesForDoubleJumpvsPlayer.m
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import "RulesForDoubleJumpvsPlayer.h"

@implementation RulesForDoubleJumpvsPlayer
+ (BOOL)captureRuleStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    
    return [self checkAllDirectionCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy]
    && [self invalidPointsListForCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy];
}

+ (BOOL)checkAllDirectionCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    int oppplayer = -1 ;
    if(PlayerPlacements.player2){
        oppplayer = 1 ;
    }else{
        oppplayer = 2 ;
    }
    
    boolean objectcanCapture = false ;
    
    if((startx-2)>=0 && (starty-2)>=0&&(startx-endx)==2&&(starty-endy)==2){
        if(list[startx-2][starty-2] == 0 && list[startx-1][starty-1] == oppplayer && ValidmoveDirections.moveDirection(startx, starty)){
            return true ;
        }
    }
    
    if((starty-2)>=0 &&(startx-endx)==0  && (starty-endy)==2 ){
        if(list[startx][starty-2]==0&& list[startx][starty-1]==oppplayer){
            return true ;
        }
    }
    if( (startx+2)<=6 && (starty-2)>=0 && (startx-endx)==-2 && (starty-endy)==2){
        if(list[startx+2][starty-2]==0 && list[startx+1][starty-1]==oppplayer && ValidmoveDirections.moveDirection(startx, starty)){
            return true ;
        }
    }
    if((startx-2)>=0  && (startx-endx) == 2 && (starty-endy) == 0){
        if(list[startx-2][starty]==0&&list[startx-1][starty]==oppplayer){
            return true ;
        }
    }
    if((startx+2)<=6 && (startx-endx) == -2 && (starty-endy) == 0){
        if(list[startx+2][starty] == 0 && list[startx+1][starty]==oppplayer){
            return true ;
        }
    }
    
    if((startx-2)>=0 &&(starty+2)<=6 && (startx-endx) == 2 && (starty-endy) == -2){
        if(list[startx-2][starty+2]==0 && list[startx-1][starty+1]==oppplayer && ValidmoveDirections.moveDirection(startx, starty)){
            return true ;
        }
    }
    
    if((starty+2)<=6 && (startx-endx) == 0 && (starty-endy) == -2){
        if(list[startx][starty+2]==0 &&list[startx][starty+1]==oppplayer){
            return true ;
        }
    }
    
    if((startx+2)<=6 &&(starty+2)<=6 && (startx-endx) == -2 && (starty-endy) == -2){
        if(list[startx+2][starty+2]==0 && list[startx+1][starty+1]==oppplayer && ValidmoveDirections.moveDirection(startx, starty)){
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
