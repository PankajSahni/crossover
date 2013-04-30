//
//  BoardUIView.h
//  crossover
//
//  Created by Pankaj on 12/03/13.
//
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
@interface BoardUIView : UIView{
    GameModel *gameModelObject;
    
}
-(void)getCapturedPlayers;
@end
