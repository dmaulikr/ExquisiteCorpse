//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Simon on 13/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "EXQGameCollectionViewController.h"

@interface EXQGameCollectionViewController () {
    NSArray *gameImages;
}

@end

@implementation EXQGameCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
	
    // Initialize recipe image array
    gameImages = @[@"download.jpeg",@"download1.jpeg",@"download2.jpeg",@"download3.jpeg",@"download5.jpeg",@"download6.jpeg", @"images.jpeg",@"images1.jpeg",@"images2.jpeg",@"images3.jpeg",@"images4.jpeg",@"images5.jpeg",@"images6.jpeg",@"images7.jpeg",@"images8.jpeg",@"images9.jpeg",@"images10.jpeg",@"images11.jpeg",@"images12.jpeg",@"images13.jpeg",@"images14.jpeg"];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return recipeImages.count;
    return gameImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[gameImages objectAtIndex:indexPath.row]];
    cell.backgroundView = nil; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.width = 580.;
    [self.collectionView reloadData];
}
@end
