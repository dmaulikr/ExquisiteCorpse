//
//  EXQScene.m
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQScene.h"
#import "EXQDrawingState.h"
#import "EXQGameState.h"
#import "EXQConf.h"

const CGFloat kEXQCanvasHeight = 328;
const CGFloat kEXQCanvas1YOffset = 100;

@implementation EXQScene

#pragma mark - Setup

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = [SKColor whiteColor];
        [self _EXQSetupCanvases];
    }
    return self;
}

#pragma mark - Setup (Private)

- (void)_EXQSetupCanvases
{
    CGSize size = CGSizeMake(self.size.width, kEXQCanvasHeight);

    // Canvases
    EXQCanvas *canvas1 = [[EXQCanvas alloc] initWithSize:size];
    EXQCanvas *canvas2 = [[EXQCanvas alloc] initWithSize:size];
    EXQCanvas *canvas3 = [[EXQCanvas alloc] initWithSize:size];
    
    canvas3.position = CGPointMake(round(size.width / 2.0), round(size.height / 2.0));
    canvas2.position = CGPointMake(canvas3.position.x, canvas3.position.y + size.height);
    canvas1.position = CGPointMake(canvas3.position.x, canvas2.position.y + size.height);
    [self addChild:canvas1];
    [self addChild:canvas2];
    [self addChild:canvas3];
    self.playerCanvas1 = canvas1;
    self.playerCanvas2 = canvas2;
    self.playerCanvas3 = canvas3;
    
    // Lines
    SKShapeNode *line1 = [SKShapeNode node];
    SKShapeNode *line2 = [SKShapeNode node];
    for (SKShapeNode *line in @[line1, line2]) {
        line.strokeColor = [EXQConf colorViewBackgroundOrange];
        line.fillColor   = nil;
        line.lineWidth   = 5;
    }
    
    CGFloat y2 = size.height, y1 = 2 * y2;
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(0, y1)];
    [bezierPath1 addLineToPoint:CGPointMake(size.width, y1)];
    line1.path = bezierPath1.CGPath;
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(0, y2)];
    [bezierPath2 addLineToPoint:CGPointMake(size.width, y2)];
    line2.path = bezierPath2.CGPath;
    
    [self addChild:line1];
    [self addChild:line2];
    self.dottedLine1 = line1;
    self.dottedLine2 = line2;
}

#pragma mark - Game state

- (void)setGameState:(EXQGameState *)gameState
{
    _gameState = gameState;
    [self updateForGamePhase:gameState.gamePhase animated:YES];
}

#pragma mark - Changing phase

- (void)updateForGamePhase:(EXQGamePhase)gamePhase animated:(BOOL)animated
{
    EXQCanvas *activeCanvas = [self activeCanvasForPhase:gamePhase];
    for (EXQCanvas *canvas in @[self.playerCanvas1, self.playerCanvas2, self.playerCanvas3]) {
        [canvas setActive:(canvas == activeCanvas) animated:YES];
    }
}

- (EXQCanvas *)activeCanvasForPhase:(EXQGamePhase)phase
{
    switch (phase) {
        case EXQGamePhaseInitialSetup:      { return nil; }
        case EXQGamePhasePlayer1Turn:       { return self.playerCanvas1; }
        case EXQGamePhasePlayer2Turn:       { return self.playerCanvas2; }
        case EXQGamePhasePlayer3Turn:       { return self.playerCanvas3; }
        case EXQGamePhaseFinished:
        default:                            { return nil; }
    }
}

#pragma mark - Canvas delegate

- (SKColor *)drawingColorForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.color;
}

- (CGFloat)drawingRadiusForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.radius;
}

- (CGFloat)drawingOpacityForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.opacity;
}



@end
