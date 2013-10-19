//
//  EXQCanvas.h
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class EXQDrawingState;

@interface EXQCanvas : SKSpriteNode

// Setup
- (id)initWithSize:(CGSize)size;

// State
@property (strong, nonatomic) EXQDrawingState *drawingState;
@property (strong, nonatomic) NSMutableArray *strokes;

// Current stroke
@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) SKShapeNode *currentStroke;

// Undo
- (IBAction)undoStroke:(id)sender;
- (void)undoLastStrokeAnimated:(BOOL)animated;

// UIImage Snapshots
- (UIImage *)snapshot;

@end
