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

//CGPoint midPoint(CGPoint p1, CGPoint p2) {
//    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
//}

- (void)_EXQInitDrawingState
{
    self.drawingState = [[EXQDrawingState alloc] init];
    self.points = [NSMutableArray array];
}

- (void)_EXQInitCanvas
{
    self.userInteractionEnabled = YES;
}

#pragma mark - Strokes

- (void)startStroke
{
    self.points = [NSMutableArray array];
    self.currentStroke = [self newStrokeShape];
    [self addChild:self.currentStroke];
}

- (void)finishStroke
{
    [self.strokes addObject:self.currentStroke];
    self.currentStroke = nil;
    self.points = nil;
}

- (void)addPoint:(CGPoint)point
{
    if (kEXQRestrictToBounds) {
        if (!CGRectContainsPoint(self.exqBounds, point))
            return;
    }
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

CGFloat EXQDistance(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x, dy = p1.y - p2.y;
    return sqrt(dx * dx + dy * dy);
}

- (void)eraseAtPoint:(CGPoint)p
{
// TODO if doing
}

- (void)redrawCurrentStroke
{
    UIBezierPath *bezierPath = [self newSmoothedBezierPathForPoints:self.points];
    if (bezierPath)
        self.currentStroke.path = [bezierPath CGPath];
}


CGPoint exqMidPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (UIBezierPath *)newSmoothedBezierPathForPoints:(NSArray *)points
{
    NSInteger count = [points count];
    if (count <= 2)
        return nil;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:[points[0] CGPointValue]];
    [bezierPath addLineToPoint:[points[1] CGPointValue]];
    for (NSInteger i = 0; i < count - 2; i++)
    {
        CGPoint currentPoint = [points[i + 2] CGPointValue];
        CGPoint previousPoint = [points[i + 1] CGPointValue];
        CGPoint midPoint = exqMidPoint(currentPoint, previousPoint);
        [bezierPath addQuadCurveToPoint:currentPoint controlPoint:midPoint];
    }
    
    return bezierPath;
}

- (SKShapeNode *)newStrokeShape
{
    SKShapeNode *shape = [SKShapeNode node];
    shape.strokeColor = [SKColor blackColor];
    shape.fillColor = nil;
    shape.lineWidth = 2;
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
    [self startStroke];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInNode:self];
    switch (self.drawingState.canvasState) {
        case EXQCanvasStateDrawing:
        {
            [self addPoint:p];
            break;
        }
        case EXQCanvasStateErasing:
        {
            [self eraseAtPoint:p];
            break;
        }
        default:
            break;
    }
    [self redrawCurrentStroke];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self finishStroke];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self finishStroke];
}


@end
