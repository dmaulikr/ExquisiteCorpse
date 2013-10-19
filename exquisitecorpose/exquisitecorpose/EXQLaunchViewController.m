//
//  EXQLaunchViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQLaunchViewController.h"

@interface EXQLaunchViewController () <UITableViewDataSource, UITableViewDelegate>

-(IBAction)startLocalGame:(id)sender;

@end

@implementation EXQLaunchViewController

- (IBAction)startLocalGame:(id)sender
{
    
}

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

#pragma mark - TableViewData Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kEXQPreviousGameCellIdentifier = @"EXQPreviousGameCellIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEXQPreviousGameCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kEXQPreviousGameCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"previous game %d", indexPath.row];
    
    return cell;
    
}

@end
