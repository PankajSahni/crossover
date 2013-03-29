//
//  RulesForDoubleJumpvsPlayer.h
//  crossover
//
//  Created by Pankaj on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface RulesForDoubleJumpvsPlayer : NSObject
+ (BOOL)captureRuleStartX:(int)start_x StartY:(int)start_y endX:(int)end_x endY:(int)end_y;
+ (BOOL)invalidPointsListForCaptureStartX:(int)startx StartY:(int)starty endX:(int)endx endY:(int)endy;
@end
