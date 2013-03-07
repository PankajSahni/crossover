//
//  ViewController.h
//  crossover
//
//  Created by Mac on 27/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSingleton.h"
#import "GlobalUtility.h"
@interface ViewController : UIViewController{
    GlobalUtility *globalUtilityObject;
}
-(void) getPopOver;
-(UIView *) getDarkBackground:(CGRect)cgrect;

-(CGRect)getNewDimensionsByReducingHeight:(int)height
                                    width:(int)width toPixel:(int)pixel;
@end
