//
//  EXQCanvas.m
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQCanvas.h"
#import "EXQDrawingState.h"

@interface EXQCanvas()
@property (assign) CGRect exqBounds;
@end

@implementation EXQCanvas

// Configuration flags
const BOOL kEXQRestrictToBounds = YES;

#pragma mark - Setup

- (id)initWithSize:(CGSize)size
{
    self = [super initWithColor:[SKColor colorWithWhite:0.98 alpha:1] size:size];
    if (self) {
        [self _EXQInitDrawingState];
        [self _EXQInitCanvas];
        CGFloat w = self.size.width, h = self.size.height;
        self.exqBounds = CGRectMake(-w/2.0, -h/2.0, w, h);
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
    self.userInteractionEnabled = YES;
}

#pragma mark - Drawing

- (void)addPoint:(CGPoint)point
{
    if (kEXQRestrictToBounds) {
        if (!CGRectContainsPoint(self.exqBounds, point))
            return;
    }
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

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInNode:self];
    [self addPoint:p];
    [self redraw]; // Ouch!
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}


@end
