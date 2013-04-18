//
//  SettingsBackgroundUIView.m
//  crossover
//
//  Created by Pankaj on 18/04/13.
//
//

#import "SettingsBackgroundUIView.h"
#import "GameModel.h"
#import "GlobalSingleton.h"
@interface SettingsBackgroundUIView ()
@property (readonly) GameModel *gameModelObject;

@end
@implementation SettingsBackgroundUIView
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
        
    }
    return self;
}

-(void) getBackground{
    NSDictionary *device_dimensions =
    [self.gameModelObject getDimensionsForMyDevice:[GlobalSingleton sharedManager].string_my_device_type];
    
    CGRect cgrect_get_popover =
    [self.gameModelObject getNewDimensionsByReducingHeight:[[device_dimensions valueForKey:@"height"] intValue]
                                                     width:[[device_dimensions valueForKey:@"width"] intValue]
                                                   toPixel:[[device_dimensions valueForKey:@"popover_size"] intValue]];
    
    UIImage *image_background = [UIImage imageNamed:@"settings_bg.png"];
    UIImageView *uiview_background =[[UIImageView alloc] initWithImage:image_background];
    uiview_background.frame = cgrect_get_popover;
    [self addSubview:uiview_background];
}

@end
