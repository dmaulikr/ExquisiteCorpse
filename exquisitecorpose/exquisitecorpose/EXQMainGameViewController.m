//
//  EXQMainGameViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQMainGameViewController.h"
#import "EXQCanvas.h"
#import "EXQGameState.h"

@interface EXQMainGameViewController ()

- (IBAction)done:(id)sender;

@end

@implementation EXQMainGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self _EXQPresentSpriteKitScene];
    [self _EXQSetupDoneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_EXQPresentSpriteKitScene
{
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    CGSize size = skView.bounds.size;
    EXQScene *scene = [EXQScene sceneWithSize:size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    self.scene = scene;
    
    // Configure the scene
    scene.gameState = self.gameState;
    
    // Present the scene
    [skView presentScene:scene];
}

- (void)_EXQSetupDoneButton
{
    //UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    //self.navigationItem.rightBarButtonItem = done;
}

#pragma mark - Drawing actions

- (IBAction)undoStroke:(id)sender
{
    [self.scene undoLastStrokeOnActiveCanvasAnimated:YES];
}

- (IBAction)done:(id)sender
{
    if (self.passAndPlay) {
        switch (self.gameState.gamePhase) {
            case EXQGamePhaseInitialSetup:
            {
                break;
            }
            case EXQGamePhasePlayer1Turn:
            case EXQGamePhasePlayer2Turn:
            case EXQGamePhasePlayer3Turn:
            {
                [self.scene nextPassAndPlayTurn];
                break;
            }
            case EXQGamePhaseFinished:
            {
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - Scene delegate

- (void)sceneDidFinishDrawing:(EXQScene *)scene
{
    //
}

- (void)scene:(EXQScene *)scene wantsChromeHidden:(BOOL)hidden
{
    self.undoButton.hidden = hidden;
    self.doneButton.hidden = hidden;
}


@end
