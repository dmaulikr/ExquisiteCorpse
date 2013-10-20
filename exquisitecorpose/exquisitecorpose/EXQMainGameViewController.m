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
#import "EXQDrawingState.h"
#import "UIImage+Helpers.h"
#import "UIView+Utilities.h"

@interface EXQMainGameViewController ()

- (IBAction)done:(id)sender;
@property (nonatomic, assign) BOOL hiddenChrome;

@end

@implementation EXQMainGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self _EXQPresentSpriteKitScene];
    [self _EXQSetupDoneButton];
    [self _EXQSetupColorButtons];
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

- (UIButton*)_buttonWithColor:(UIColor*)color
{
    CGFloat d = 40.;
    CGSize sz = CGSizeMake(d, d);
    CGRect r = CGRectMake(0, 0, d, d);
    
    UIImage *img = [UIImage imageWithColor:color size:sz];
    UIButton *button = [[UIButton alloc] initWithFrame:r];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    button.centerX = self.view.right;

    button.hidden = self.hiddenChrome;
    [button setcornerRadius:d/2.];
    [button setborderWidth:2.0];
    [button setborderColor:[UIColor darkGrayColor]];
    button.clipsToBounds = YES;
    return button;
}

- (void)_EXQSetupColorButtons
{
    self.blackButton = [self _buttonWithColor:[UIColor blackColor]];
    [self.view addSubview:_blackButton];
    [_blackButton addTarget:self action:@selector(blackAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackButton.top = CGRectGetMidY(self.view.bounds)-100;
    
    self.redButton = [self _buttonWithColor:[UIColor redColor]];
    [self.view addSubview:_redButton];
    [_redButton addTarget:self action:@selector(redAction:) forControlEvents:UIControlEventTouchUpInside];
    _redButton.top = CGRectGetMidY(self.view.bounds)-50;
    
    self.blueButton = [self _buttonWithColor:[UIColor blueColor]];
    [self.view addSubview:_blueButton];
    [_blueButton addTarget:self action:@selector(blueAction:) forControlEvents:UIControlEventTouchUpInside];
    _blueButton.top = CGRectGetMidY(self.view.bounds);
}
- (void)_EXQSetupDoneButton
{
    //UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    //self.navigationItem.rightBarButtonItem = done;
}

#pragma mark - Drawing configuration

- (IBAction)redAction:(id)sender
{
    self.scene.drawingState.color = [SKColor redColor];
    
}
- (IBAction)blackAction:(id)sender
{
    self.scene.drawingState.color = [UIColor blackColor];
}
- (IBAction)blueAction:(id)sender
{
    self.scene.drawingState.color = [UIColor blueColor];
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
    self.hiddenChrome = hidden;
    
    self.undoButton.hidden = hidden;
    self.doneButton.hidden = hidden;
    self.redButton.hidden = hidden;
    self.blueButton.hidden = hidden;
    self.blackButton.hidden = hidden;
}


@end
