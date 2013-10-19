//
//  EXQMainCollectionViewController.m
//  exquisitecorpose
//
//  Created by Reid van Melle on 2013-10-19.
//  Copyright (c) 2013 Startup Weekend. All rights reserved.
//

#import "EXQMainCollectionViewController.h"
#import "EXQShareViewController.h"

@interface EXQMainCollectionViewController ()

@property (nonatomic, retain) NSArray *gameImages;

@end

@implementation EXQMainCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIViewController*)viewControllerFromStoryboard:(NSString *)vcid
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcid];
    return vc;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EXQNewGameController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
        }];
    } else if (indexPath.section == 1) {
        EXQShareViewController *vc = (EXQShareViewController*)[self viewControllerFromStoryboard:@"EXQShareController"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc setImage:[UIImage imageNamed:[self.gameImages objectAtIndex:indexPath.row]]];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.gameImages.count;
    }
    return 0;
}

- (UICollectionViewCell*)newGameCell:(UICollectionView*)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewGameCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    

    return cell;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self newGameCell:collectionView forItemAtIndexPath:indexPath];
    }
    
    static NSString *identifier = @"GalleryCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *iv = (UIImageView *)[cell viewWithTag:100];
    iv.image = [UIImage imageNamed:[self.gameImages objectAtIndex:indexPath.row]];
    cell.backgroundView = nil; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize recipe image array
    self.gameImages = @[@"download.jpeg",@"download1.jpeg",@"download2.jpeg",@"download3.jpeg",@"download5.jpeg",@"download6.jpeg", @"images.jpeg",@"images1.jpeg",@"images2.jpeg",@"images3.jpeg",@"images4.jpeg",@"images5.jpeg",@"images6.jpeg",@"images7.jpeg",@"images8.jpeg",@"images9.jpeg",@"images10.jpeg",@"images11.jpeg",@"images12.jpeg",@"images13.jpeg",@"images14.jpeg"];
}

@end
