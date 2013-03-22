//
//  GameModel.h
//  crossover
//
//  Created by Pankaj on 07/03/13.
//
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject
@property (nonatomic, retain) NSMutableDictionary *dictionary_my_device_dimensions;
-(NSDictionary *)getDimensionsForMyDevice:(NSString *)device_type;
-(NSMutableArray *)getBoardDimensions;
@end
