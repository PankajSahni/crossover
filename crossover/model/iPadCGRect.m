//
//  iPadCGRect.m
//  crossover
//
//  Created by Pankaj on 17/04/13.
//
//

#import "iPadCGRect.h"

@implementation iPadCGRect



-(CGRect)pauseButtonCGRect{
    return CGRectMake(730, 170, 50, 50);
}
-(CGRect)refreshButtonCGRect{
    return CGRectMake(790, 170, 50, 50);
}
-(CGRect)settingsButtonCGRect{
    return CGRectMake(850, 170, 50, 50);
}
-(CGRect)shareButtonCGRect{
    return CGRectMake(910, 170, 50, 50);
}
-(CGRect)mainmenuButtonCGRect{
    return CGRectMake(120, 130, 50, 50);
}
-(CGRect)labelPlayerOneCGRect{
    return CGRectMake(910, 280, 70, 35);
}
-(CGRect)labelPlayerTwoCGRect{
    return CGRectMake(910, 555, 70, 35);
}
-(NSDictionary *)arrayPlayersCapturedCGRect{
    
   return [[NSDictionary alloc] initWithObjectsAndKeys:@"680", @"int_x",
           @"330", @"int_y_p1",
           @"470", @"int_y_p2",
           @"35", @"int_x_increment",
           @"40", @"int_y_increment",
           @"30", @"width",
           @"30", @"height", nil];
}
-(NSDictionary *)arrayCoinsCGRect{
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"35", @"int_x",
            @"163", @"int_y",
            @"80", @"int_increment",
            @"40", @"width",
            @"40", @"height", nil];
}
@end
