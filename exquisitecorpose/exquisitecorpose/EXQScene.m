//
//  EXQScene.m
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQScene.h"
#import "EXQDrawingState.h"
#import "EXQGameState.h"
#import "EXQConf.h"

const CGFloat kEXQCanvasHeight = 328;
const CGFloat kEXQCanvas1YOffset = 100;

@implementation EXQScene

#pragma mark - Setup

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = [SKColor whiteColor];
        [self _EXQSetupCanvases];
    }
    return self;
}

#pragma mark - Setup (Private)

- (void)_EXQSetupCanvases
{
    // World
    self.world = [SKNode node];
    [self addChild:self.world];
    
    CGSize size = CGSizeMake(self.size.width, kEXQCanvasHeight);

    // Canvases
    EXQCanvas *canvas1 = [[EXQCanvas alloc] initWithSize:size];
    EXQCanvas *canvas2 = [[EXQCanvas alloc] initWithSize:size];
    EXQCanvas *canvas3 = [[EXQCanvas alloc] initWithSize:size];
    
    canvas3.position = CGPointMake(round(size.width / 2.0), round(size.height / 2.0));
    canvas2.position = CGPointMake(canvas3.position.x, canvas3.position.y + size.height);
    canvas1.position = CGPointMake(canvas3.position.x, canvas2.position.y + size.height);
    [self.world addChild:canvas1];
    [self.world addChild:canvas2];
    [self.world addChild:canvas3];
    self.playerCanvas1 = canvas1;
    self.playerCanvas2 = canvas2;
    self.playerCanvas3 = canvas3;
    
    // Masks
    SKSpriteNode *mask1 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas1.size];
    SKSpriteNode *mask2 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas2.size];
    SKSpriteNode *mask3 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas3.size];
    mask1.position = canvas1.position;
    mask2.position = canvas2.position;
    mask3.position = canvas3.position;
    for (SKSpriteNode *mask in @[mask1, mask2, mask3]) {
        mask.userInteractionEnabled = NO;
    }
    
//    [self.world addChild:mask1];
//    [self.world addChild:mask2];
//    [self.world addChild:mask3];
    self.mask1 = mask1;
    self.mask2 = mask2;
    self.mask3 = mask3;
    
    // Lines
    SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithImageNamed:@"dashed_line.png"];
    SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithImageNamed:@"dashed_line.png"];
    line1.position = CGPointMake(size.width / 2.0, size.height * 2.0);
    line2.position = CGPointMake(size.width / 2.0, size.height);
    [self.world addChild:line1];
    [self.world addChild:line2];
    self.dottedLine1 = line1;
    self.dottedLine2 = line2;
}

#pragma mark - Game state

- (void)setGameState:(EXQGameState *)gameState
{
    _gameState = gameState;
    [self updateGamePhase:gameState.gamePhase animated:YES];
}

#pragma mark - Undo

- (void)undoLastStrokeOnActiveCanvasAnimated:(BOOL)animated
{
    EXQCanvas *activeCanvas = nil;
    if (self.gameState.gamePhase == EXQGamePhasePlayer1Turn)
        activeCanvas = [self canvases][0];
    else if (self.gameState.gamePhase == EXQGamePhasePlayer2Turn)
        activeCanvas = [self canvases][1];
    else if (self.gameState.gamePhase == EXQGamePhasePlayer2Turn)
        activeCanvas = [self canvases][2];
    [activeCanvas undoLastStrokeAnimated:YES];
}

#pragma mark - Changing phase

- (NSArray *)masks
{
    return @[self.mask1, self.mask2, self.mask3];
}

- (NSArray *)canvases
{
    return @[self.playerCanvas1, self.playerCanvas2, self.playerCanvas3];
}

- (void)updateGamePhase:(EXQGamePhase)gamePhase animated:(BOOL)animated
{
    _gameState.gamePhase = gamePhase;
    [self hideInstructionsForInitialSetup];
    CGPoint newPositionForWorld = CGPointZero;
    switch (gamePhase) {
        case EXQGamePhaseInitialSetup:
        {
            [self setMaskIndex:0 visible:NO animated:NO];
            [self setMaskIndex:1 visible:NO animated:NO];
            [self setMaskIndex:2 visible:NO animated:NO];
            [self setCanvasActiveAtIndex:NSNotFound];
            [self showInstructionsForInitialSetup];
            break;
        }
        case EXQGamePhasePlayer1Turn:
        {
            [self setMaskIndex:0 visible:NO animated:YES];
            [self setMaskIndex:1 visible:YES animated:YES];
            [self setMaskIndex:2 visible:YES animated:YES];
            [self setCanvasActiveAtIndex:0];
            newPositionForWorld = CGPointMake(0, -200);
            break;
        }
        case EXQGamePhasePlayer2Turn:
        {
            [self setMaskIndex:0 visible:YES animated:YES];
            [self setMaskIndex:1 visible:NO animated:YES];
            [self setMaskIndex:2 visible:YES animated:YES];
            [self setCanvasActiveAtIndex:1];
            break;
        }
        case EXQGamePhasePlayer3Turn:
        {
            [self setMaskIndex:0 visible:YES animated:YES];
            [self setMaskIndex:1 visible:YES animated:YES];
            [self setMaskIndex:2 visible:NO animated:YES];
            [self setCanvasActiveAtIndex:2];
            newPositionForWorld = CGPointMake(0, 200);
            break;
        }
        case EXQGamePhaseFinished:
        default:
        {
            [self setMaskIndex:0 visible:NO animated:YES];
            [self setMaskIndex:1 visible:NO animated:YES];
            [self setMaskIndex:2 visible:NO animated:YES];
            [self setCanvasActiveAtIndex:NSNotFound];
            break;
        }
    }
    
    NSTimeInterval duration = animated ? 0.4 : 0;
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *moveWorld = [SKAction moveTo:newPositionForWorld duration:duration];
    SKAction *sequence = [SKAction sequence:@[ wait, moveWorld ]];
    [self.world runAction:sequence];
}

- (void)setCanvasActiveAtIndex:(NSInteger)integer
{
    for (NSInteger i = 0; i < 3; i++) {
        BOOL active = (i == integer);
        EXQCanvas *canvas = [self canvases][i];
        canvas.active = active;
        canvas.userInteractionEnabled = active;
    }
}

- (void)setMaskIndex:(NSInteger)index visible:(BOOL)visible animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.2 : 0;
    SKSpriteNode *mask = [self masks][index];
    if (visible) {
        [self updateTextureForMaskIndex:index];
        mask.alpha = 0;
        if (!mask.parent)
            [self.world addChild:mask];
        [mask runAction:[SKAction fadeInWithDuration:duration]];
    } else {
        [mask runAction:[SKAction fadeOutWithDuration:duration]];
    }
}

- (void)updateTextureForMaskIndex:(NSInteger)index
{
    EXQCanvas *canvas = [self canvases][index];
    SKSpriteNode *mask = [self masks][index];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"
                                keysAndValues:@"inputRadius", @80, nil];
    mask.texture = [canvas.texture textureByApplyingCIFilter:blur];
}

- (void)showInstructionsForInitialSetup
{
    SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    text.text = @"REPLACE: Tap to start";
    text.fontSize = 26;
    text.fontColor = [EXQConf colorTextWhite];
    text.position = CGPointMake(0, -11);
    
    SKSpriteNode *innerHelp = [SKSpriteNode spriteNodeWithColor:[EXQConf colorViewBackgroundOrange] size:text.frame.size];
    innerHelp.position = CGPointZero; //CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    [innerHelp addChild:text];
    
    SKSpriteNode *help = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:0 alpha:0.3] size:self.size];
    help.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    help.name = @"HelpText";
    [help addChild:innerHelp];
    
    [self.world addChild:help];
}

- (void)hideInstructionsForInitialSetup
{
    SKLabelNode *help = (SKLabelNode *)[self.world childNodeWithName:@"HelpText"];
    [help runAction:[SKAction fadeOutWithDuration:0.3]
         completion:^{ [help removeFromParent]; }];
}

#pragma mark - Canvas delegate

- (SKColor *)drawingColorForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.color;
}

- (CGFloat)drawingRadiusForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.radius;
}

- (CGFloat)drawingOpacityForCanvas:(EXQCanvas *)canvas
{
    return self.drawingState.opacity;
}

#pragma mark - Responder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.gameState.gamePhase == EXQGamePhaseInitialSetup)
        [self updateGamePhase:EXQGamePhasePlayer1Turn animated:YES];
}



@end
