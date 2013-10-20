//
//  EXQGameState.h
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    EXQGamePhaseInitialSetup = 0,
    EXQGamePhasePlayer1Turn,
    EXQGamePhasePlayer2Turn,
    EXQGamePhasePlayer3Turn,
    EXQGamePhaseFinished
} EXQGamePhase;

@interface EXQGameState : NSObject
<NSCoding>

// Setup
+ (EXQGameState *)gameState;
+ (EXQGameState *)bootstrapGameState;       // Boostrap data

@property (assign) EXQGamePhase gamePhase;
@property (strong, nonatomic) NSArray *strokesForPlayer1;
@property (strong, nonatomic) NSArray *strokesForPlayer2;
@property (strong, nonatomic) NSArray *strokesForPlayer3;


@end
