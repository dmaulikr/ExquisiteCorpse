//
//  EXQShareViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQShareViewController.h"

@interface EXQShareViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *img;

@end

@implementation EXQShareViewController



- (void)setImage:(UIImage*)img
{
    _img = img;
    self.imageView.image = img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.img;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
