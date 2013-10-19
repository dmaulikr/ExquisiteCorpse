//
//  EXQDrawingState.h
//  exquisitecorpose
//
//  Created by Josh Svatek on 10/19/2013.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    EXQStrokeTypeDefault = 0,
} EXQStrokeType;

@interface EXQDrawingState : NSObject

@property (assign) CGFloat opacity;
@property (assign) CGFloat radius;
@property (strong, nonatomic) SKColor *color;
@property (assign) EXQStrokeType strokeType;


@end
