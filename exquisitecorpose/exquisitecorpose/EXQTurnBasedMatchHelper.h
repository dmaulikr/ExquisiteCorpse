//
//  EXQTurnBasedMatchHelper.h
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface EXQTurnBasedMatchHelper : NSObject

@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, retain) NSArray *gameCenterFriends;
@property (nonatomic, weak) UIViewController *presentingViewController;

+ (EXQTurnBasedMatchHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController;

@end
