//
//  RulesForSingleJumpVsPalyer.m
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import "RulesForSingleJumpVsPalyer.h"
#import "ValidMoveDirections.h"
#import "GlobalSingleton.h"
@implementation RulesForSingleJumpVsPalyer
+ (BOOL)captureRuleStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    
    return [self checkAllDirectionMoveStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy]
    && [self singleJumpStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy];
}

+(BOOL)singleJumpStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    if(startx==1&&starty==2 &&endx == 2&& endy == 1)
    {
        return false ;
    }
    if(startx==2&&starty==1 &&endx == 1&& endy == 2)
    {
        return false ;
    }
    if(startx==1 && starty==4 &&endx == 2&& endy == 5)
    {
        return false ;
    }
    if(startx==2 &&starty==5 &&endx == 1&& endy == 4)
    {
        return false ;
    }
    if(startx==4&&starty==1 &&endx == 5&& endy == 2)
    {
        return false ;
    }
    if(startx==5&&starty==2 &&endx == 4&& endy == 1)
    {
        return false ;
    }
    if(startx==5 && starty==4 && endx == 4 && endy == 5)
    {
        return false ;
    }
    if(startx==4&&starty==5 &&endx == 5&& endy == 4)
    {
        return false ;
    }
    return true ;
}


+(BOOL)checkAllDirectionMoveStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy{
    if((startx-1)>=0 && (starty-1)>=0 && (startx-endx)==1&&(starty-endy)==1){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-1 AndCoumn:(int)starty-1] == 0
           && [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ; 
        }
    }
    
    if((starty-1)>=0 &&(startx-endx)==0  && (starty-endy)==1 ){
        //NSLog(@"hello %d", [self getCellStatusWithRow:(int)startx AndCoumn:(int)starty-1]);
        
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty-1]==0){
            
            return true ;
        }
    }
    if( (startx+1)<=6 && (starty-1)>=0 && (startx-endx)==-1 && (starty-endy)==1){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty-1]==0
           && [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    if((startx-1)>=0  && (startx-endx) == 1  && (starty-endy) == 0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx-1 AndCoumn:(int)starty]==0){
            return true ;
        }
    }
    if((startx+1)<=6 && (startx-endx) == -1 && (starty-endy) == 0){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty] == 0 ){
            return true ;
        }
    }
    
    if((startx-1)>=0 &&(starty+1)<=6 && (startx-endx) == 1 && (starty-endy) == -1){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty-1]==0
           && [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    
    if((starty+1)<=6 && (startx-endx) == 0 && (starty-endy) == -1){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx AndCoumn:(int)starty+1]==0 ){
            return true ;
        }
    }
    
    if((startx+1)<=6 &&(starty+1)<=6 && (startx-endx) == -1 && (starty-endy) == -1){
        if([[GlobalSingleton sharedManager] getCellStatusWithRow:(int)startx+1 AndCoumn:(int)starty+1]==0
           && [ValidMoveDirections moveDirectionRow:startx column:starty]){
            return true ;
        }
    }
    return false ;
}


@end
