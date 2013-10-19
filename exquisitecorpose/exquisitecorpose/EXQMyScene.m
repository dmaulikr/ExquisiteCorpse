//
//  EXQMyScene.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQMyScene.h"
#import "EXQCanvas.h"

@implementation EXQMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        EXQCanvas *canvas = [[EXQCanvas alloc] initWithSize:CGSizeMake(600, 600)];
        canvas.position = CGPointMake(round(size.width / 2.0), round(size.height / 2.0));
        [self addChild:canvas];
        self.canvas = canvas;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
