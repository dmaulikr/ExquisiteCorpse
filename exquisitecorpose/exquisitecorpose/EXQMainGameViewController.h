//
//  EXQMainGameViewController.h
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQBaseViewController.h"
@class EXQCanvas, EXQMyScene, EXQGameState;

@interface EXQMainGameViewController : EXQBaseViewController

// Game state
@property (strong, nonatomic) EXQGameState *gameState;

// SpriteKit nodes
@property (strong, nonatomic) EXQCanvas *canvas;
@property (strong, nonatomic) EXQMyScene *scene;

// Controls
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
- (IBAction)undoStroke:(id)sender;

@end
