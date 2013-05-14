//
//  GCTurnBasedMatchHelper.m
//  spinningyarn
//
//  Created by Ray Wenderlich on 10/8/11.
//  Copyright 2011 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "GCTurnBasedMatchHelper.h"
#import "GlobalSingleton.h"
@implementation GCTurnBasedMatchHelper
@synthesize gameCenterAvailable;
@synthesize currentMatch;
@synthesize delegate;

#pragma mark Initialization

static GCTurnBasedMatchHelper *sharedHelper = nil;
+ (GCTurnBasedMatchHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCTurnBasedMatchHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer     
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && 
        !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        NSLog(@"[UIDevice currentDevice] systemVersion %@",[[UIDevice currentDevice] systemVersion]);
        [self findMatchWithMinPlayers:2 maxPlayers:2 viewController:[GlobalSingleton sharedManager].game_uiviewcontroller];
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && 
               userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions
/*
- (void)authenticateLocalUser { 
    
    if (!gameCenterAvailable) return;
    
    void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error){
        GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
        ev.delegate = self;
    };
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
        [[GKLocalPlayer localPlayer] 
         authenticateWithCompletionHandler:setGKEventHandlerDelegate];        
    } else {
        NSLog(@"Already authenticated!");
        [self findMatchWithMinPlayers:2 maxPlayers:2 viewController:[GlobalSingleton sharedManager].game_uiviewcontroller];
        setGKEventHandlerDelegate(nil);
    }
}
*/
-(void)authenticateLocalUser {
    
    if (!self.checkingLocalPlayer) {
        self.checkingLocalPlayer = YES;
        GKLocalPlayer *thisPlayer = [GKLocalPlayer localPlayer];
        
        if (!thisPlayer.authenticated) {
            
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
                
                [thisPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
                    
                    if (viewcontroller) {
                        [self.delegate presentViewController:viewcontroller];
                    } else {
                        NSLog(@"error %@", error);
                        ///[self finishGameCenterAuthWithError:error];
                    }
                    
                })];
                
            } else {
                
                [[GKLocalPlayer localPlayer]
                 authenticateWithCompletionHandler:^(NSError *error)
                 {
                     [self finishGameCenterAuthWithError:error];
                 }
                 ];
            }
            
        }
    }
}
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController {
    if (!gameCenterAvailable) return;               
    
    presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];    
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [presentingViewController presentModalViewController:mmvc animated:YES];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

-(void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.currentMatch = match;
    NSLog(@"match.participants %@",match.participants);
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    GKTurnBasedParticipant *secondParticipant = [match.participants objectAtIndex:1];
    
//    /[self lookupPlayers:match.participants];
    if (![firstParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        [self playerForPlayerID:(NSString *)firstParticipant.playerID];
    }else{
        [self playerForPlayerID:(NSString *)secondParticipant.playerID];
    }
    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        NSLog(@"It's a new game!");
        [GlobalSingleton sharedManager].gc_newgame = TRUE;
        [delegate enterNewGame:match];
        
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            NSLog(@"It's your turn!");
            
            // It's your turn!
            [delegate takeTurn:match];
        } else {
            NSLog(@"// It's not your turn, just display the game state.");
            // It's not your turn, just display the game state.
            [delegate layoutMatch:match];
        }        
    }
}

- (void)playerForPlayerID:(NSString*)playerID {
    [GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
        } else {
            // Populate players dict
            for (GKPlayer *player in players) {
                [GlobalSingleton sharedManager].gc_opponent = player.alias;
                [delegate updatePlayerLabels];
            }
        }
    }];
}
/*
- (void)getPlayersForMatch:(GKTurnBasedMatch*)match {
    
    NSMutableArray *identifiers = [NSMutableArray array];
    
    for(GKTurnBasedParticipant *participant in match.participants) {
        if(participant.playerID == nil) {
            continue;
        }
        [identifiers addObject:participant.playerID];
    }
    
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
        } else {
            // Populate players dict
            for (GKPlayer *player in players) {
                [self.playersDict setObject:player forKey:player.playerID];
            }
            [self.delegate playersLoaded];
        }
    }];
}

- (void)getPlayersForMatches:(NSArray*)matches {
    NSMutableArray *identifiers = [NSMutableArray array];
    
    for(GKTurnBasedMatch *match in matches) {
        for(GKTurnBasedParticipant *participant in match.participants) {
            if(participant.playerID == nil) {
                continue;
            }
            [identifiers addObject:participant.playerID];
        }
    }
    
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
        } else {
            // Populate players dict
            for (GKPlayer *player in players) {
                [self.playersDict setObject:player forKey:player.playerID];
            }
            [self.delegate playersLoaded];
        }
    }];
}
- (void)lookupPlayers:(NSArray *)playersIDs{
    
    [GKPlayer loadPlayersForIdentifiers:playersIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil) {
            
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
        } else {
            
            // Populate players dict
            NSMutableDictionary *playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                
                NSLog(@"Found player: %@", player.alias);
                [GlobalSingleton sharedManager].gc_opponent = player.alias;
                [playersDict setObject:player forKey:player.playerID];
            }
            
        }
        
    }];
    
}
*/
-(void)turnBasedMatchmakerViewControllerWasCancelled: (GKTurnBasedMatchmakerViewController *)viewController {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    [delegate matchMakingCancelledByUserGCHelper];
    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    [delegate matchMakingCancelledByUserGCHelper];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:(currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        } 
    }
    NSLog(@"playerquitforMatch, %@, %@", match, match.currentParticipant);
    [delegate matchMakingCancelledByUserGCHelper];
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipant:part matchData:match.matchData completionHandler:nil];
}

#pragma mark GKTurnBasedEventHandlerDelegate

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 12;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController =
    [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [presentingViewController presentModalViewController:viewController animated:YES];
}
-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [delegate takeTurn:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [delegate layoutMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [delegate sendNotice:@"It's your turn for another match" forMatch:match];
        } else {
            // it's the not current match, and it's someone else's turn
        }
    }
}

-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    NSString *matchString         = @"Deleting match";
    NSData *matchData            = [matchString dataUsingEncoding:NSUTF8StringEncoding];
    [match endMatchInTurnWithMatchData:matchData completionHandler:^(NSError *error)
     {
         NSLog(@"Error ending the match: %@", error);
         
         //   and then remove it
         [match removeWithCompletionHandler:^(NSError *error)
          {
              NSLog(@"Error removing match: %@", error);
          }];
     }];
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        [delegate recieveEndGame:match];
    } else {
        [delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }
[self deleteMatch];

}

-(void)deleteMatch{
    //   load all of the matches the player is currently a part of
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
    {
        NSLog(@"Error loading matches: %@", error);
        
        //   create some placeholder match data
        NSString *matchString         = @"Deleting match";
        NSData *matchData            = [matchString dataUsingEncoding:NSUTF8StringEncoding];
        
        //   for each match
        for (GKTurnBasedMatch *match in matches)
        {
            //   log the id of the match
            NSLog(@"ID of match we are removing: %@", match.matchID);
            
            //   for each player we set their outcome to 'tied'
            for (GKTurnBasedParticipant *participant in match.participants)
                participant.matchOutcome      = GKTurnBasedMatchOutcomeTied;
            
            //   end the match
            [match endMatchInTurnWithMatchData:matchData completionHandler:^(NSError *error)
             {
                 NSLog(@"Error ending the match: %@", error);
                 
                 //   and then remove it
                 [match removeWithCompletionHandler:^(NSError *error)
                  {
                      NSLog(@"Error removing match: %@", error);
                  }];
             }];
        }
    }];
}
/*
- (void)removeFromGameCenter
{
    [match removeWithCompletionHandler:^(NSError * error)
     {
         if (error)
         {
             NSLog(@"Error removing match %@: %@",
                   _match.matchID, error.localizedDescription);
             return;
         }
         
         NSLog(@"Match %@ removed from Game Center",
               _match.matchID);
         _terminated = YES;
     }];
}*/
@end
