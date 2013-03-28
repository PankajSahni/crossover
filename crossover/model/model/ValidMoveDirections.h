//
//  ValidMoveDirections.h
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface ValidMoveDirections : NSObject
+(BOOL)moveDirectionRow:(int)row column:(int)col;
+(BOOL)moveDirectionforPlayerRowStart:(int)rowstart ColumnStart:(int)colstart RowEnd:(int)rowend ColumnEnd:(int)colend;
@end
