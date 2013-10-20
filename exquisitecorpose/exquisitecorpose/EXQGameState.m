//
//  EXQGameState.m
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQGameState.h"


@implementation EXQGameState

NSString * const kEXQGameStateSerializationKeyGamePhase = @"GamePhase";
NSString * const kEXQGameStateSerializationKeyStrokesPlayer1 = @"StrokesPlayer1";
NSString * const kEXQGameStateSerializationKeyStrokesPlayer2 = @"StrokesPlayer2";
NSString * const kEXQGameStateSerializationKeyStrokesPlayer3 = @"StrokesPlayer3";



#pragma mark - Setup

+ (EXQGameState *)gameState
{
    return [[self alloc] init];
}

+ (EXQGameState *)bootstrapGameState
{
    EXQGameState *gameState = [self gameState];
    // Configure it
    return gameState;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.gamePhase = [decoder decodeIntegerForKey:kEXQGameStateSerializationKeyGamePhase];
        self.strokesForPlayer1 = [decoder decodeObjectForKey:kEXQGameStateSerializationKeyStrokesPlayer1];
        self.strokesForPlayer2 = [decoder decodeObjectForKey:kEXQGameStateSerializationKeyStrokesPlayer2];
        self.strokesForPlayer3 = [decoder decodeObjectForKey:kEXQGameStateSerializationKeyStrokesPlayer3];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.gamePhase forKey:kEXQGameStateSerializationKeyGamePhase];
    [encoder encodeObject:self.strokesForPlayer1 forKey:kEXQGameStateSerializationKeyStrokesPlayer1];
    [encoder encodeObject:self.strokesForPlayer2 forKey:kEXQGameStateSerializationKeyStrokesPlayer2];
    [encoder encodeObject:self.strokesForPlayer3 forKey:kEXQGameStateSerializationKeyStrokesPlayer3];
}


@end
