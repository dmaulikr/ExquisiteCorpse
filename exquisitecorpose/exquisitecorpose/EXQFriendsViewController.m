//
//  EXQFriendsViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQFriendsViewController.h"
#import "EXQTurnBasedMatchHelper.h"

@interface EXQFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EXQFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *friends = [EXQTurnBasedMatchHelper sharedInstance].gameCenterFriends;
    return friends.count;
}

- (void) loadPlayerPhoto: (GKPlayer*) player
{
    /*[player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (photo != nil)
        {
            [self storePhoto: photo forPlayer: player];
        }
        if (error != nil)
        {
            // Handle the error if necessary.
        }
    }];*/
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSArray *friends = [EXQTurnBasedMatchHelper sharedInstance].gameCenterFriends;
    return nil;
}

@end
