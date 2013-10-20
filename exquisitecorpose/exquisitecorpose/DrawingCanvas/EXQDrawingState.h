//
//  EXQDrawingState.h
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface EXQDrawingState : NSObject

@property (strong, nonatomic) SKColor *color;
@property (assign) CGFloat radius;
@property (assign) CGFloat opacity;

@end
