//
//  BoardUIView.m
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import "BoardUIView.h"

@implementation BoardUIView
@synthesize imageview_crossover_logo1;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(100, 100, 100, 100)];
        UIImage *image_crossover_logo = [UIImage imageNamed:@"images/crossover.png"];
        imageview_crossover_logo1 =
        [[UIImageView alloc] initWithImage:image_crossover_logo];
        imageview_crossover_logo1.frame = self.bounds;
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //position button
        myButton.frame = self.bounds;
        [myButton setTitle:@"Click" forState:UIControlStateNormal];
        [myButton setBackgroundColor:[UIColor redColor]];
        // add targets and actions
        [myButton addTarget:self action:@selector(myButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        // add to a view
        [imageview_crossover_logo1 addSubview:myButton];
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
