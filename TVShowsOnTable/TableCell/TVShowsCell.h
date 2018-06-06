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

/**
 handle favourite/unfavourite user actions (UI visuaks)

 @param sender UIButton sending the event
 */
- (IBAction)favouriteUnfavouriteButtonPressed:(UIButton *)sender;


#pragma mark - Delegate

/**
 Cell delegate. The event is received by the corresponding ViewModel.
 */
@property (weak, nonatomic) id <FavoritesHandlingDelegate> favouriteHandlingDelegate;


/**
 Instance method setting up cell properties 

 @param Object Object of which cell properties will be set
 */

@end
