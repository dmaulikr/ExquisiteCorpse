//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Simon on 13/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "EXQGameCollectionViewController.h"

@interface EXQGameCollectionViewController () {
    NSArray *recipeImages;
    NSArray *gameImages;
}

@end

@implementation EXQGameCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
	
    // Initialize recipe image array
    recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
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
