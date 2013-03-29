//
//  AiEngine.h
//  crossover
//
//  Created by Pankaj on 28/03/13.
//
//

#import <Foundation/Foundation.h>

@interface AiEngine : NSObject
@property (nonatomic, retain) NSMutableArray *moves;
@property (nonatomic, retain) NSMutableArray *safemoves;
@property (nonatomic, retain) NSMutableArray *capturelist;
@property (nonatomic, retain) NSMutableArray *safecapturelist;
@property (nonatomic, retain) NSMutableArray *savelist;
-(void)playerOne;
@end
