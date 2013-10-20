//
//  EXQNewGameViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQNewGameViewController.h"
#import "EXQTurnBasedMatchHelper.h"

@interface EXQNewGameViewController ()

- (IBAction)cancelAction;

@end

@implementation EXQNewGameViewController

- (IBAction)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)presentGCTurnViewController:(id)sender {
    [[EXQTurnBasedMatchHelper sharedInstance] findMatchWithMinPlayers:3 maxPlayers:3 viewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
