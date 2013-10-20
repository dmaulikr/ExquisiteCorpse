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
//        CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"
//                                    keysAndValues:@"inputRadius", @80, nil];
//        self.filter = blur;
//        self.shouldRasterize = YES;
//        self.shouldEnableEffects = NO;
        [self _createHackyMasks];
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
//    SKSpriteNode *mask1 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas1.size];
//    SKSpriteNode *mask2 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas2.size];
//    SKSpriteNode *mask3 = [SKSpriteNode spriteNodeWithTexture:nil size:canvas3.size];
//    mask1.position = canvas1.position;
//    mask2.position = canvas2.position;
//    mask3.position = canvas3.position;
//    for (SKSpriteNode *mask in @[mask1, mask2, mask3]) {
//        mask.userInteractionEnabled = NO;
//    }
    
//    [self.world addChild:mask1];
//    [self.world addChild:mask2];
//    [self.world addChild:mask3];
//    self.mask1 = mask1;
//    self.mask2 = mask2;
//    self.mask3 = mask3;
    
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
    else if (self.gameState.gamePhase == EXQGamePhasePlayer3Turn)
        activeCanvas = [self canvases][2];
    [activeCanvas undoLastStrokeAnimated:YES];
}

#pragma mark - Changing phase

- (NSArray *)masks
{
    return nil;
//    return @[self.mask1, self.mask2, self.mask3];
}

- (NSArray *)canvases
{
    return @[self.playerCanvas1, self.playerCanvas2, self.playerCanvas3];
}

- (void)updateGamePhase:(EXQGamePhase)gamePhase animated:(BOOL)animated
{
    _gameState.gamePhase = gamePhase;
    [self hideInstructionsForInitialSetup];
    [self hidePassAndPlayCover];
    NSTimeInterval duration = animated ? 0.4 : 0;
    CGPoint newPositionForWorld = CGPointZero;
    switch (gamePhase) {
        case EXQGamePhaseInitialSetup:
        {
            [self setMaskIndex:0 visible:NO animated:NO];
            [self setMaskIndex:1 visible:NO animated:NO];
            [self setMaskIndex:2 visible:NO animated:NO];
            [self setCanvasActiveAtIndex:NSNotFound];
            [self showPassAndPlayCoverWithText:@"Get ready! It's your turn."];
            break;
        }
        case EXQGamePhasePlayer1Turn:
        {
            [self setMaskIndex:0 visible:NO animated:YES];
            [self setMaskIndex:1 visible:YES animated:YES];
            [self setMaskIndex:2 visible:YES animated:YES];
            [self setCanvasActiveAtIndex:0];
            newPositionForWorld = CGPointMake(0, -kEXQCanvasHeight);
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
            newPositionForWorld = CGPointMake(0, kEXQCanvasHeight);
            break;
        }
        case EXQGamePhaseFinished:
        default:
        {
            [self.delegate scene:self wantsChromeHidden:YES];
            [self setMaskIndex:0 visible:NO animated:YES];
            [self setMaskIndex:1 visible:NO animated:YES];
            [self setMaskIndex:2 visible:NO animated:YES];
            [self setCanvasActiveAtIndex:NSNotFound];
            newPositionForWorld = CGPointZero;
            
            SKAction *wait = [SKAction waitForDuration:1.4];
            SKAction *fade = [SKAction fadeAlphaTo:0.15 duration:0.7];
            SKAction *sequence = [SKAction sequence:@[ wait, fade ]];
            
            [self.dottedLine1 runAction:sequence
                             completion:^{
//                [self.world removeChildrenInArray:@[self.dottedLine1]];
            }];
            [self.dottedLine2 runAction:sequence
                             completion:^{
//                [self.world removeChildrenInArray:@[self.dottedLine2]];
            }];
            break;
        }
    }
    
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *moveWorld = [SKAction moveTo:newPositionForWorld duration:duration];
    SKAction *sequence = [SKAction sequence:@[ wait, moveWorld ]];
    __weak EXQScene *weakSelf = self;
    BOOL shouldShowMasks = (self.gameState.gamePhase == EXQGamePhasePlayer1Turn || self.gameState.gamePhase == EXQGamePhasePlayer2Turn || self.gameState.gamePhase == EXQGamePhasePlayer3Turn);
    [self.world runAction:sequence
               completion:^{
                   [weakSelf setHackyMasksVisible:shouldShowMasks animated:YES];
               }];
}

- (void)setCanvasActiveAtIndex:(NSInteger)integer
{
    for (NSInteger i = 0; i < 3; i++) {
        BOOL active = (i == integer);
        EXQCanvas *canvas = [self canvases][i];
        canvas.active = active;
        canvas.userInteractionEnabled = active;
    }
    
    /*for (NSInteger i = 0; i < 3; i++) {
        EXQCanvas *canvas = [self canvases][i];
        canvas.active = YES;
        canvas.userInteractionEnabled = YES;
    }*/
}

- (void)setMaskIndex:(NSInteger)index visible:(BOOL)visible animated:(BOOL)animated
{
    return;
    NSTimeInterval duration = animated ? 0.2 : 0;
    SKSpriteNode *mask = [self masks][index];
    if (visible) {
        [self updateTextureForMaskIndex:index];
        mask.alpha = 0;
        if (!mask.parent)
            [self.world addChild:mask];
        [mask runAction:[SKAction fadeInWithDuration:duration]];
    } else {
        [mask runAction:[SKAction fadeOutWithDuration:duration] completion:^{
            [self.world removeChildrenInArray:@[mask]];
        }];
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

- (UIImage *)newSnapshotImageForRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)showPassAndPlayCoverWithText:(NSString *)text
{
    [self.delegate scene:self wantsChromeHidden:YES];
    
//    UIImage *image = [self newSnapshotImageForRect:self.frame];
//    SKTexture *tex = [SKTexture textureWithImage:image];
//    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"
//                                keysAndValues:@"inputRadius", @40, nil];
//    SKTexture *blurredTex = [tex textureByApplyingCIFilter:blur];
//
    SKSpriteNode *cover = [SKSpriteNode spriteNodeWithColor:[EXQConf colorViewBackgroundOrange] size:self.size];
//    SKSpriteNode *cover = [SKSpriteNode spriteNodeWithTexture:blurredTex];
    cover.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    cover.name = @"BackgroundCoverNode";
    cover.alpha = 0;
    [self addChild:cover];
    
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    textNode.text = text;
    textNode.fontSize = 38;
    textNode.fontColor = [SKColor whiteColor];
    textNode.position = CGPointZero; //CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    [cover addChild:textNode];

    [cover runAction:[SKAction fadeInWithDuration:0.2]
          completion:^{
              //
          }];
}

- (void)hidePassAndPlayCover
{
    BOOL hideChrome = self.gameState.gamePhase == EXQGamePhaseFinished;
    [self.delegate scene:self wantsChromeHidden:hideChrome];
    SKNode *node = [self childNodeWithName:@"BackgroundCoverNode"];
    [node runAction:[SKAction fadeOutWithDuration:0.2]
         completion:^{ [node removeFromParent]; }];
}

#pragma mark - Pass and play

- (void)nextPassAndPlayTurn
{
    switch (self.gameState.gamePhase) {
        case EXQGamePhasePlayer1Turn:
        {
            [self updateGamePhase:EXQGamePhasePlayer2Turn animated:YES];

            [self showPassAndPlayCoverWithText:@"Best. Doodle. Ever! Ok, next player's turn!"];
            break;
        }
        case EXQGamePhasePlayer2Turn:
        {
            [self updateGamePhase:EXQGamePhasePlayer3Turn animated:YES];
            [self showPassAndPlayCoverWithText:@"Rad! Ok, next player's turn!"];
            break;
        }
        case EXQGamePhasePlayer3Turn:
        {
            [self updateGamePhase:EXQGamePhaseFinished animated:YES];
            [self showPassAndPlayCoverWithText:@"Sweet! Tap to reveal the drawing"];
            break;
        }
        case EXQGamePhaseFinished:
        {
            NSLog(@"HEY");
        }
        default:
            break;
    }
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
    
    if (self.gameState.gamePhase == EXQGamePhaseInitialSetup) {
        [self hidePassAndPlayCover];
        [self updateGamePhase:EXQGamePhasePlayer1Turn animated:YES];
        return;
    }

    // Is there a cover up?
    SKNode *cover = [self childNodeWithName:@"BackgroundCoverNode"];
    if (cover) {
        [self hidePassAndPlayCover];
    }
    
}

#pragma mark - Hacky masks

NSString * const kEXQHackyTopMark = @"HackyTopMask";
NSString * const kEXQHackyBottomMark = @"HackyBottomMask";

- (void)_createHackyMasks
{
    CGFloat totalH = self.size.height - kEXQCanvasHeight;
    CGFloat h = totalH / 2.0;
    SKSpriteNode *top = [SKSpriteNode spriteNodeWithColor:[EXQConf colorViewBackgroundOrange] size:CGSizeMake(self.size.width, h)];
    top.position = CGPointMake(self.size.width / 2.0, self.size.height - h / 2.0);
    SKSpriteNode *bottom = [SKSpriteNode spriteNodeWithColor:[EXQConf colorViewBackgroundOrange] size:CGSizeMake(self.size.width, h)];
    bottom.position = CGPointMake(self.size.width / 2.0, + h / 2.0);
    top.alpha = 0, bottom.alpha = 0;
    top.name = kEXQHackyTopMark, bottom.name = kEXQHackyBottomMark;
    [self addChild:top];
    [self addChild:bottom];
}

- (void)setHackyMasksVisible:(BOOL)visible animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.2 : 0;
    SKAction *action = visible ? [SKAction fadeInWithDuration:duration] : [SKAction fadeOutWithDuration:duration];
    [[self childNodeWithName:kEXQHackyTopMark] runAction:action];
    [[self childNodeWithName:kEXQHackyBottomMark] runAction:action];
}


@end
