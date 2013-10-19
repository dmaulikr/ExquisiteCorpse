//
//  SketchView.m
//
//  Created by Shawn Hyam on 2013-04-18.
//  Copyright (c) 2013
//

#import "EXQSketchView.h"
#import <QuartzCore/QuartzCore.h>

@interface EXQSketchView ()
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) CAShapeLayer *activeDrawingLayer;
@property (nonatomic, strong) UIImageView *backgroundImageView;

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation EXQSketchView

#pragma mark -

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (NSMutableArray*)drawingStack {
    if (!_drawingStack) {
        _drawingStack = [NSMutableArray arrayWithCapacity:16];
    }
    return _drawingStack;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createDrawingLayer {
    self.points = [NSMutableArray arrayWithCapacity:128];
    
    // set up the drawing layer
    self.activeDrawingLayer = [[CAShapeLayer alloc] init];
    self.activeDrawingLayer.lineWidth = self.lineWidth;
    self.activeDrawingLayer.strokeColor = self.color.CGColor;
    self.activeDrawingLayer.lineCap = kCALineCapRound;
    self.activeDrawingLayer.lineJoin = kCALineJoinRound;
    self.activeDrawingLayer.fillColor = nil;
    
    [self.layer addSublayer:self.activeDrawingLayer];
    [self.drawingStack addObject:self.activeDrawingLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.drawingRoutineType == kDrawingRoutineTypeNone) return;
    
    if (touches.count > 1) {
        [self touchesCancelled:touches withEvent:event];
        return;
    }
    
    [self createDrawingLayer];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self.points addObject:[NSValue valueWithCGPoint:location]];
    [self refreshDrawingLayer];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.drawingRoutineType == kDrawingRoutineTypeNone) return;

    if (touches.count > 1) {
        [self touchesCancelled:touches withEvent:event];
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self.points addObject:[NSValue valueWithCGPoint:location]];
    [self refreshDrawingLayer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.drawingRoutineType == kDrawingRoutineTypeNone) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self.points addObject:[NSValue valueWithCGPoint:location]];
    [self refreshDrawingLayer];
    [self resetDrawingLayer];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.drawingRoutineType == kDrawingRoutineTypeNone) return;
    // should not have drawn these touches, I think
    
    [self resetDrawingLayer];
    [self refreshDrawingLayer];
    [self.drawingStack removeLastObject];
}

- (void)addViewToStack:(UIView *)view {
    [self.drawingStack addObject:view];
}

#pragma mark - Sketching

- (void)refreshDrawingLayer {
    if (self.drawingRoutineType == kDrawingRoutineTypeFreehand) {
        if (self.points.count < 1) {
            self.activeDrawingLayer.path = nil;
            return;
        }
        
        if (self.points.count == 1) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPoint pt = [[self.points objectAtIndex:0] CGPointValue];
            CGPathMoveToPoint(path, &CGAffineTransformIdentity, pt.x, pt.y);
            CGPathAddLineToPoint(path, &CGAffineTransformIdentity, pt.x, pt.y);
            self.activeDrawingLayer.path = path;
            CGPathRelease(path);
            return;
            
        }
        
        if (self.points.count == 2) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPoint pt = [[self.points objectAtIndex:0] CGPointValue];
            CGPoint pt2 = [[self.points objectAtIndex:1] CGPointValue];
            CGPathMoveToPoint(path, &CGAffineTransformIdentity, pt.x, pt.y);
            CGPathAddLineToPoint(path, &CGAffineTransformIdentity, pt2.x, pt2.y);
            self.activeDrawingLayer.path = path;
            CGPathRelease(path);
            return;
        }
        
        int idx = self.points.count-1;
        CGPoint previousPoint2  = [[self.points objectAtIndex:idx-2] CGPointValue];
        CGPoint previousPoint1  = [[self.points objectAtIndex:idx-1] CGPointValue];
        CGPoint currentPoint    = [[self.points objectAtIndex:idx] CGPointValue];
        
        // calculate mid point
        CGPoint mid1    = midPoint(previousPoint1, previousPoint2);
        CGPoint mid2    = midPoint(currentPoint, previousPoint1);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
        CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        
        CGMutablePathRef oldPath;
        if (self.activeDrawingLayer.path) {
            oldPath = CGPathCreateMutableCopy(self.activeDrawingLayer.path);
            CGPathAddPath(oldPath, &CGAffineTransformIdentity, path);
            self.activeDrawingLayer.path = oldPath;
            CGPathRelease(oldPath);
        } else {
            self.activeDrawingLayer.path = path;
        }
        CGPathRelease(path);
    } else if (self.drawingRoutineType == kDrawingRoutineTypeLine) {
        if (self.points.count < 2) {
            self.activeDrawingLayer.path = NULL;
            return;
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        NSValue *v0 = [self.points objectAtIndex:0];
        CGPoint pt0 = [v0 CGPointValue];
        CGPathMoveToPoint(path, &CGAffineTransformIdentity, pt0.x, pt0.y);
        
        NSValue *v1 = [self.points lastObject];
        CGPoint pt1 = [v1 CGPointValue];
        CGPathAddLineToPoint(path, &CGAffineTransformIdentity, pt1.x, pt1.y);
        
        self.activeDrawingLayer.path = path;
        CGPathRelease(path);
    } else if (self.drawingRoutineType == kDrawingRoutineTypeRectangle) {
        if (self.points.count < 2) {
            self.activeDrawingLayer.path = NULL;
            return;
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        NSValue *v0 = [self.points objectAtIndex:0];
        CGPoint pt0 = [v0 CGPointValue];
        CGPathMoveToPoint(path, &CGAffineTransformIdentity, pt0.x, pt0.y);
        
        NSValue *v1 = [self.points lastObject];
        CGPoint pt1 = [v1 CGPointValue];
        CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(pt0.x, pt0.y, pt1.x-pt0.x, pt1.y-pt0.y));
        
        self.activeDrawingLayer.path = path;
        CGPathRelease(path);
    } else if (self.drawingRoutineType == kDrawingRoutineTypeRound) {
        if (self.points.count < 2) {
            self.activeDrawingLayer.path = NULL;
            return;
        }
        
        NSValue *v0 = [self.points objectAtIndex:0];
        CGPoint pt0 = [v0 CGPointValue];
        
        NSValue *v1 = [self.points lastObject];
        CGPoint pt1 = [v1 CGPointValue];
        
        UIBezierPath *bp = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pt0.x, pt0.y, pt1.x-pt0.x, pt1.y-pt0.y)];
        self.activeDrawingLayer.path = bp.CGPath;
    }
}

- (void)resetDrawingLayer {
    [self.points removeAllObjects];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    [self.backgroundImageView removeFromSuperview];
    
    _backgroundImage = backgroundImage;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    iv.frame = self.bounds;
    iv.contentMode = UIViewContentModeScaleToFill;
    iv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:iv];
    self.backgroundImageView = iv;
}

- (UIImage*)renderImage {
    CGSize sz = self.bounds.size;
    
    UIGraphicsBeginImageContext(sz);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (YES) {
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(context, CGRectMake(0, 0, sz.width, sz.height));
    }

    [self.layer renderInContext:context];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void)clear {
    for (id obj in self.drawingStack) {
        if ([obj isKindOfClass:[CALayer class]]) {
            [obj removeFromSuperlayer];
        } else if ([obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }
    [self.drawingStack removeAllObjects];
}

@end
