//
//  EXQScene.h
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class EXQCanvas, EXQScene, EXQDrawingState, EXQGameState;

@protocol EXQSceneDelegate <NSObject>
- (void)sceneDidFinishDrawing:(EXQScene *)scene;
- (void)scene:(EXQScene *)scene wantsChromeHidden:(BOOL)hidden;
@end


@interface EXQScene : SKScene

// Canvases
@property (strong, nonatomic) SKNode *world;
@property (strong, nonatomic) EXQCanvas *playerCanvas1;
@property (strong, nonatomic) EXQCanvas *playerCanvas2;
@property (strong, nonatomic) EXQCanvas *playerCanvas3;
@property (strong, nonatomic) SKSpriteNode *mask1;
@property (strong, nonatomic) SKSpriteNode *mask2;
@property (strong, nonatomic) SKSpriteNode *mask3;
@property (strong, nonatomic) SKSpriteNode *dottedLine1;
@property (strong, nonatomic) SKSpriteNode *dottedLine2;

// Undo
- (void)undoLastStrokeOnActiveCanvasAnimated:(BOOL)animated;

// Actions
- (void)nextPassAndPlayTurn;

// Delegate
@property (weak, nonatomic) id<EXQSceneDelegate> delegate;

// State
@property (strong, nonatomic) EXQDrawingState *drawingState;
@property (strong, nonatomic) EXQGameState *gameState;

// Show Cover
- (void)showCoverNodeWithText:(NSString *)text;

// Holy moley
@property (strong, nonatomic) UIImage *snapshot1;
@property (strong, nonatomic) UIImage *snapshot2;
@property (strong, nonatomic) UIImage *snapshot3;


@end
