//
//  EXQTurnBasedMatchHelper.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQTurnBasedMatchHelper.h"

@interface EXQTurnBasedMatchHelper () <GKTurnBasedMatchmakerViewControllerDelegate>

@property (nonatomic, assign) BOOL userAuthenticated;

@end

@implementation EXQTurnBasedMatchHelper

static EXQTurnBasedMatchHelper *sharedHelper = nil;

+ (EXQTurnBasedMatchHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[EXQTurnBasedMatchHelper alloc] init];
    }
    return sharedHelper;
}

- (id)init {
    if ((self = [super init])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(authenticationChanged)
                   name:GKPlayerAuthenticationDidChangeNotificationName
                 object:nil];
    }
    return self;
}

- (void) loadPlayerData: (NSArray *) identifiers
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil)
        {
            self.gameCenterFriends = players;
        }
    }];
}

- (void)retrieveFriends
{
    GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
    if (lp.authenticated)
    {
        [lp loadFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error) {
            if (friendIDs != nil)
            {
                [self loadPlayerData: friendIDs];
            }
        }];
    }
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !self.userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        self.userAuthenticated = YES;
        [self retrieveFriends];
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && self.userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        self.userAuthenticated = NO;
    }
    
}

- (BOOL)isGameCenterAvailable { return self.userAuthenticated; }

- (void)authenticateLocalUser
{
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *vc, NSError *err) {
            [self retrieveFriends];
            NSLog(@"AUTHENTICATED");
        }];
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController {
    
    self.presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [self.presentingViewController presentViewController:mmvc animated:YES completion:^{
        
    }];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{

    }];
    NSLog(@"did find match, %@", match);
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];

    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];

    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"playerquitforMatch, %@, %@", match, match.currentParticipant);
}

@end
