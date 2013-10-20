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

const CGFloat kEXQCanvasHeight = 260;
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
    
    canvas3.position = CGPointMake(0, -round(size.height + kEXQCanvas1YOffset) / 2.0);
    canvas2.position = CGPointMake(0, canvas3.position.y + kEXQCanvas1YOffset);
    canvas1.position = CGPointMake(0, canvas2.position.y + kEXQCanvas1YOffset);
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
    CGFloat x0 = round(-size.width / 2.0), x1 = -x0;
    CGFloat y0 = canvas1.position.y - kEXQCanvas1YOffset / 2.0;
    CGFloat y1 = y0 + kEXQCanvas1YOffset;
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(x0, y0)];
    [bezierPath1 addLineToPoint:CGPointMake(x1, y0)];
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(x0, y1)];
    [bezierPath2 addLineToPoint:CGPointMake(x1, y1)];
    CGFloat dashLengths[2] = {2.0, 2.0};
    for (UIBezierPath *path in @[bezierPath1, bezierPath2]) {
        [path setLineDash:dashLengths count:2 phase:0];
    }
    line1.path = bezierPath1.CGPath;
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
    //
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
