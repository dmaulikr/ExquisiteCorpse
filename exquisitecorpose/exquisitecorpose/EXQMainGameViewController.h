//
//  EXQMainGameViewController.h
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQBaseViewController.h"
#import "EXQScene.h"
@class EXQCanvas, EXQGameState;

@interface EXQMainGameViewController : EXQBaseViewController
<EXQSceneDelegate>

// Game state
@property (strong, nonatomic) EXQGameState *gameState;
@property (assign, getter = passAndPlay) BOOL passAndPlay;

// SpriteKit nodes
@property (strong, nonatomic) EXQCanvas *canvas;
@property (strong, nonatomic) EXQScene *scene;

// Controls
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)undoStroke:(id)sender;
- (IBAction)done:(id)sender;

@end
