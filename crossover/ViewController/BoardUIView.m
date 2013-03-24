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
        [self getCross];
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
    UIImage *image_background = [UIImage imageNamed:@"blank.png"];
    UIImageView *imageview_background = [[UIImageView alloc] initWithImage:image_background];
    CGRect rect_temp = CGRectMake(0 , 0,
                           [[device_dimensions valueForKey:@"width"] intValue],
                           [[device_dimensions valueForKey:@"height"] intValue]);
    imageview_background.frame = rect_temp;
    [self addSubview:imageview_background];
    
    /*player 1 background */
    UIImage *image_captured_bg = [UIImage imageNamed:@"captured_bg.png"];
    UIImageView *imageview_captured_bg_one = 
    [[UIImageView alloc] initWithImage:image_captured_bg];
    rect_temp = [[GlobalSingleton sharedManager] 
                 getFrameAccordingToDeviceWithXvalue:650 yValue:200 width:320 height:200];
    imageview_captured_bg_one.frame = rect_temp;
    [self addSubview:imageview_captured_bg_one];
    /*player 1 background */
    
    /*player 1 background */
    UIImage *image_captured_bg_two = [UIImage imageNamed:@"captured_bg.png"];
    UIImageView *imageview_captured_bg_two = 
    [[UIImageView alloc] initWithImage:image_captured_bg_two];
    rect_temp = [[GlobalSingleton sharedManager] 
                 getFrameAccordingToDeviceWithXvalue:650 yValue:450 width:320 height:200];
    imageview_captured_bg_two.frame = rect_temp;
    [self addSubview:imageview_captured_bg_two];
    /*player 1 background */
}
@end
