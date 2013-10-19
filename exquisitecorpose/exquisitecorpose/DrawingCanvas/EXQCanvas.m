//
//  EXQCanvas.m
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQCanvas.h"
#import "EXQDrawingState.h"

@implementation EXQCanvas

#pragma mark - Setup

- (id)initWithSize:(CGSize)size
{
    self = [super initWithColor:[SKColor colorWithWhite:0.98 alpha:1] size:size];
    if (self) {
        [self _EXQInitDrawingState];
        [self _EXQInitCanvas];
    }
    return self;
}

#pragma mark - Setup (Private)

- (void)_EXQInitDrawingState
{
    self.drawingState = [[EXQDrawingState alloc] init];
    self.points = [NSMutableArray array];
}

- (void)_EXQInitCanvas
{
    
}

#pragma mark - Drawing

- (void)addPoint:(CGPoint)point
{
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (void)redraw
{
    [self removeAllChildren];
    self.line = [self newShapeFromPoints:self.points];
    if (self.line) {
        [self addChild:self.line];
    }
}

- (SKShapeNode *)newShapeFromPoints:(NSArray *)points
{
    NSParameterAssert([points count] > 0);
    UIBezierPath *path = [self newBezierPathFromPoints:points];
    if (!path)
        return nil;
    
    SKShapeNode *shape = [SKShapeNode node];
    shape.strokeColor = [SKColor blackColor];
    shape.fillColor = nil;
    shape.lineWidth = 2;
    shape.path = [path CGPath];
    return shape;
}

- (UIBezierPath *)newBezierPathFromPoints:(NSArray *)points
{
    if ([points count] < 2) {
        NSLog(@"Line too short to draw");
        return nil;
    }
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    // LINEAR?!?
    CGPoint lastPoint = [points[0] CGPointValue];
    [bezierPath moveToPoint:lastPoint];
    for (NSInteger i = 0; i < ([points count] - 1); i++) {
        CGPoint nextPoint = [points[i + 1] CGPointValue];
//        [bezierPath addCurveToPoint:nextPoint controlPoint1:lastPoint controlPoint2:nextPoint];
        [bezierPath addLineToPoint:nextPoint];
        lastPoint = nextPoint;
    }
    return bezierPath;
}


@end
