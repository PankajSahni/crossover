//
//  BoardUIView.m
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import "BoardUIView.h"
#import "GlobalSingleton.h"
#import "GlobalUtility.h"

@interface BoardUIView ()
@property (readonly) GlobalUtility *globalUtilityObject;
@end


@implementation BoardUIView
- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
    }
    return globalUtilityObject;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        // Initialization code
        CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:50 yValue:170 width:560 height:560];
        [self setFrame:cgrect_temp];
        self.backgroundColor = [UIColor greenColor];
        UIImage *image_board = [UIImage imageNamed:@"images/board.png"];
        UIImageView *imageview_board =
        [[UIImageView alloc] initWithImage:image_board];
        cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:15 yValue:15 width:530 height:530];
        imageview_board.frame = cgrect_temp;
        
        
        
        //position button
        NSDictionary *board_dimensions = [self.globalUtilityObject getBoardDimensions];
        //NSLog(@"board_dimensions %@",board_dimensions);
        
        NSEnumerator *enu_board_dimensions = [board_dimensions objectEnumerator];

        [self addSubview:imageview_board];
        for(NSDictionary *dict_x_y in enu_board_dimensions) {
            //NSLog(@"%@", dict_x_y);
            //NSLog(@"%@", [dict_x_y valueForKey:@"x"]);
            //NSLog(@"%@", [dict_x_y valueForKey:@"y"]);
            CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:[[dict_x_y valueForKey:@"x"] intValue]
                                                    yValue:[[dict_x_y valueForKey:@"y"] intValue]
                                                       width:40 height:40];
            NSLog(@"cgrect%@",NSStringFromCGRect(cgrect_temp));
            UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            myButton.frame = cgrect_temp;
            NSString *image_player = @"images/i13.png";
            [myButton setBackgroundImage:[UIImage imageNamed:image_player]
                                forState:UIControlStateNormal];
            [myButton addTarget:self action:@selector(playerVsPlayer:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:myButton];
        }
        
        
    }
    return self;
}

-(void)playerVsPlayer:(id)sender{
    NSLog(@"board view");

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
