//
//  BoardUIView.m
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import "BoardUIView.h"

@implementation BoardUIView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(100, 100, 100, 100)];
        UIImage *image_board = [UIImage imageNamed:@"images/board.png"];
        UIImageView *imageview_board =
        [[UIImageView alloc] initWithImage:image_board];
        imageview_board.frame = CGRectMake(50, 50, 100, 100);
        
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
    NSLog(@"move2");

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
