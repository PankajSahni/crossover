//
//  ValidMoveDirections.m
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import "ValidMoveDirections.h"

@implementation ValidMoveDirections


+(BOOL)moveDirectionRow:(int)row column:(int)col{
    if(row%2==0 && col%2==0){
        return true ;
    }else if(row%2==0 && col%2==1){
        return false ;
    }else if(row%2==1 && col%2==0){
        return false ;
    }else if(row%2==1 && col%2==1){
        return true ;
    }
    return false ;
}

+(BOOL)moveDirectionforPlayerRowStart:(int)rowstart ColumnStart:(int)colstart RowEnd:(int)rowend ColumnEnd:(int)colend{
    if(rowstart%2==0 && colstart%2==0){
        return true ;
    }else if(rowstart%2==0 && colstart%2==1){
        return false ;
    }else if(rowstart%2==1 && colstart%2==0){
        return false ;
    }else if(rowstart%2==1 && colstart%2==1){
        return true ;
    }
    return false ;
}
@end
