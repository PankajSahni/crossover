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
        
    
        CGRect cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:50 yValue:170 width:560 height:560];
        [self setFrame:cgrect_temp];
        //self.backgroundColor = [UIColor greenColor];
        UIImage *image_board = [UIImage imageNamed:@"images/board.png"];
        UIImageView *imageview_board =
        [[UIImageView alloc] initWithImage:image_board];
        cgrect_temp = [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:15 yValue:15 width:530 height:530];
        imageview_board.frame = cgrect_temp;
        [self addSubview:imageview_board];
        
 
        
    }
    return self;
}

-(void)playerVsPlayer:(id)sender{
    NSLog(@"board view");

}

-(UIButton *)getCoinWithPlayer:(UIButton *)button ForPlayer:(NSString *)player{
    NSString *image_player = @"";
    if([player isEqualToString:@"1"]){
        image_player = @"images/i5.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                                        forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    }
    else if([player isEqualToString:@"2"]){
       image_player = @"images/i19.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
    forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    }
    else if([player isEqualToString:@"0"]){
        image_player = @"images/blanckbtn_big.png";
        [button setBackgroundImage:[UIImage imageNamed:image_player]
                          forState:UIControlStateNormal];
    }
    else{
        
    }
    
    return button;
    
}


- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    NSLog(@"previous inside %@", NSStringFromCGPoint(pPrev));
    NSLog(@"now inside %@", NSStringFromCGPoint(p));
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}
@end
