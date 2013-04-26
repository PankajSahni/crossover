//
//  iPhoneCGRect.m
//  crossover
//
//  Created by Pankaj on 17/04/13.
//
//

#import "iPhoneCGRect.h"

@implementation iPhoneCGRect


-(CGRect)mainmenuButtonCGRect{
    return CGRectMake(50, 40, 25, 25);
}
-(CGRect)pauseButtonCGRect{
    return CGRectMake(320, 50, 25, 25);
}
-(CGRect)refreshButtonCGRect{
    return CGRectMake(355, 50, 25, 25);
}
-(CGRect)settingsButtonCGRect{
    return CGRectMake(390, 50, 25, 25);
}
-(CGRect)shareButtonCGRect{
    return CGRectMake(425, 50, 25, 25);
}
-(CGRect)labelPlayerOneCGRect{
    return CGRectMake(417, 223, 70, 35);
}
-(CGRect)labelPlayerTwoCGRect{
    return CGRectMake(417, 94, 70, 35);
}
-(CGRect)labelplayerOneTurnCGRect{
    return CGRectMake(330, 230, 60, 20);
}
-(CGRect)labelplayerTwoTurnCGRect{
    return CGRectMake(330, 102, 60, 20);
}
-(int)settingFontSize{
    return 12;
}
-(NSDictionary *)arrayPlayersCapturedCGRect{
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"328", @"int_x",
            @"130", @"int_y_p1",
            @"190", @"int_y_p2",
            @"15", @"int_x_increment",
            @"15", @"int_y_increment",
            @"12", @"width",
            @"12", @"height", nil];
}
-(NSDictionary *)arrayCoinsCGRect{
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"29", @"int_x",
            @"44", @"int_y",
            @"37", @"int_increment",
            @"16", @"width",
            @"16", @"height", nil];
}
@end
