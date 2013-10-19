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
@property (strong, nonatomic) NSMutableArray *points;

// Nodes
@property (strong, nonatomic) SKShapeNode *line;

@end
