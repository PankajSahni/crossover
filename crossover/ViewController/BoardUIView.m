//
//  BoardUIView.m
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import "BoardUIView.h"
#import "GlobalSingleton.h"
#import "GameModel.h"

@interface BoardUIView ()
@property (readonly) GameModel *gameModelObject;
@end


@implementation BoardUIView
- (GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
    }
    return gameModelObject;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *device_dimensions =
        [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
        CGRect cgrect_temp = CGRectMake(0 , 0,
                                        [[device_dimensions valueForKey:@"width"] intValue],
                                        [[device_dimensions valueForKey:@"height"] intValue]);
        [self setFrame:cgrect_temp];
        [self getBackground];
        //[self getCross];
        [self getCapturedPlayers];
    }
    return self;
}
-(void)getCross{
    UIImage *image_board = [UIImage imageNamed:@"board.png"];
    UIImageView *imageview_board =
    [[UIImageView alloc] initWithImage:image_board];
   CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:62 yValue:180 width:540 height:540];
    imageview_board.frame = cgrect_temp;
    [self addSubview:imageview_board];
}
-(void)getBackground{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    UIImage *image_background = [UIImage imageNamed:@"bg_main.png"];
    UIImageView *imageview_background = [[UIImageView alloc] initWithImage:image_background];
    CGRect rect_temp = CGRectMake(0 , 0,
                           [[device_dimensions valueForKey:@"width"] intValue],
                           [[device_dimensions valueForKey:@"height"] intValue]);
    imageview_background.frame = rect_temp;
    [self addSubview:imageview_background];

}


-(void)getCapturedPlayers{
    [self.gameModelObject setPlayersCapturedCGRect];
    
    for (int i = 0; i <= 15; i ++) {
        UIImage *image_captured_player_at_position = [UIImage imageNamed:@"blank_coin.png"];
        UIImageView *imageview_temp_1 = [[UIImageView alloc] initWithImage:image_captured_player_at_position];
        imageview_temp_1.frame =
        [[[GlobalSingleton sharedManager].array_captured_p1_cgrect objectAtIndex:i] CGRectValue];
        [self addSubview:imageview_temp_1];
        
        UIImageView *imageview_temp_2 = [[UIImageView alloc] initWithImage:image_captured_player_at_position];
        imageview_temp_2.frame =
        [[[GlobalSingleton sharedManager].array_captured_p2_cgrect objectAtIndex:i] CGRectValue];
        [self addSubview:imageview_temp_2];
    }
}
@end
