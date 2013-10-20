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

- (void)gameCenterError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Center Error"
                                                        message:@"You must be authenticated in game center to perform this operation."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)startGameWithFriends:(id)sender
{
    if ([EXQTurnBasedMatchHelper sharedInstance].gameCenterAvailable) {
        UIViewController *vc = [self viewControllerFromStoryboard:@"EXQFriendsController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self gameCenterError];
    }
}

- (IBAction)presentGCTurnViewController:(id)sender {
    if ([EXQTurnBasedMatchHelper sharedInstance].gameCenterAvailable) {
        [[EXQTurnBasedMatchHelper sharedInstance] findMatchWithMinPlayers:3 maxPlayers:3 viewController:self];
    } else {
        [self gameCenterError];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [EXQConf colorViewBackgroundOrange];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
