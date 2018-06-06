//
//  TVShowsCell.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"

//#import "FavoritesHandlingDelegate.h"

@protocol FavoritesHandlingDelegate;
@interface TVShowsCell : UITableViewCell

#pragma mark - IBOutlets

/**
 ImageView for displaying show images
 */
@property (weak, nonatomic) IBOutlet UIImageView *tvShowsImage;

/**
 Label displaying the show title
 */
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;

/**
 Label displaying show description
 */
@property (weak, nonatomic) IBOutlet UILabel *showsTitleDescription;

/**
 Label displaying show rating
 */
@property (weak, nonatomic) IBOutlet UILabel *showAverageRatingLabel;

/**
 ImageView displaying the show's media type
 */
@property (strong, nonatomic) IBOutlet UIImageView *showTypeImageView;

/**
 Favourite/Unfavourite show
 */
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

#pragma mark - IBActions

- (IBAction)favouriteUnfavouriteButtonPressed:(UIButton *)sender;


#pragma mark - Delegate

@property (weak, nonatomic) id <FavoritesHandlingDelegate> favouriteHandlingDelegate;


/**
 Instance method setting up cell properties 

 @param Object Object of which cell properties will be set
 */
//TO-DO: Consider removing this function
- (void)setupCellPropertiesWithObject:(Show *)Object;

@end
