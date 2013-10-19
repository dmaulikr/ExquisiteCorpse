//
//  EXQBaseViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQBaseViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "EXQAppDelegate.h"

@interface EXQBaseViewController ()

@end

@implementation EXQBaseViewController

- (EXQAppDelegate*)appDelegate
{
    return (EXQAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (UIViewController*)viewControllerFromStoryboard:(NSString *)vcid
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcid];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    if (revealController) {
    
        [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
        
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                             style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                                  style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
        
        self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
