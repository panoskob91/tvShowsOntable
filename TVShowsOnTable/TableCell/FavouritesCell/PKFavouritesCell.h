//
//  PKFavouritesCell.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShowsCell.h"
#import "FavoritesHandlingDelegate.h"

@interface PKFavouritesCell : TVShowsCell

#pragma mark - Outlets

@property (strong, nonatomic) IBOutlet UIImageView *favouriteShowMainImage;
@property (strong, nonatomic) IBOutlet UILabel *favouriteShowTitle;
@property (strong, nonatomic) IBOutlet UIImageView *favoriteShowMediaTypeImageIndicator;
@property (strong, nonatomic) IBOutlet UIButton *favoriteUnfavoriteButton;

#pragma mark - Delegate propery
@property (weak, nonatomic) id <FavoritesHandlingDelegate> favoritesHandlingDelegate;

#pragma mark - IBActions

- (IBAction)favoriteUnfavoriteShowWasPressed:(UIButton *)sender;



@end
