//
//  EXQNewGameViewController.h
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQBaseViewController.h"
@class EXQNewGameViewController;

@protocol EXQNewGameViewControllerDelegate <NSObject>
- (void)newViewControllerStartedLocalGame:(EXQNewGameViewController *)newViewController;
@end

@interface EXQNewGameViewController : EXQBaseViewController

- (IBAction)startLocalGame:(id)sender;

@property (weak, nonatomic) id<EXQNewGameViewControllerDelegate> delegate;

@end
