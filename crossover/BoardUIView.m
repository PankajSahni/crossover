//
//  BoardUIView.m
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import "BoardUIView.h"
#import "GlobalSingleton.h"
@implementation BoardUIView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:40 yValue:160 width:550 height:550];
        [self setFrame:cgrect_temp];
        self.backgroundColor = [UIColor greenColor];
        UIImage *image_board = [UIImage imageNamed:@"images/board.png"];
        UIImageView *imageview_board =
        [[UIImageView alloc] initWithImage:image_board];
        cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:20 yValue:20 width:600 height:500];
        imageview_board.frame = self.bounds;
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //position button
        myButton.frame = CGRectMake(75, 75, 50, 50);
        [myButton setTitle:@"Click" forState:UIControlStateNormal];
        [myButton setBackgroundColor:[UIColor redColor]];
        // add targets and actions
        [myButton addTarget:self action:@selector(myButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        // add to a view
        //[imageview_board addSubview:myButton];
        [self addSubview:imageview_board];
        [self addSubview:myButton];
    }
    return self;
}

-(void)myButtonClicked:(id)sender{
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
