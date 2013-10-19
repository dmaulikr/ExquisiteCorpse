//
//  EXQSketchViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQSketchViewController.h"
#import "EXQSketchView.h"

@interface EXQSketchViewController ()

@property (nonatomic, retain) EXQSketchView *sketchView;

@end

@implementation EXQSketchViewController

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
    self.sketchView = [[EXQSketchView alloc] initWithFrame:self.view.bounds];
    self.sketchView.color = [UIColor blackColor];
    self.sketchView.lineWidth = 5;
    self.sketchView.userInteractionEnabled = YES;
    [self.view addSubview:self.sketchView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
