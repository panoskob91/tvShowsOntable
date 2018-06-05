//
//  PKSummaryCellDetailsVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShowsCell.h"

//Delegates
//#import "FavoritesHandlingDelegate.h"

@protocol FavoritesHandlingDelegate;
@interface PKSummaryCellDetailsVC : TVShowsCell

//Outlets
@property (strong, nonatomic) IBOutlet UILabel *detailsCellDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailsCellTextView;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;
@property (strong, nonatomic) IBOutlet UIView *detailsCellBackgroundView;

//Delgates
@property (nonatomic, weak) id <FavoritesHandlingDelegate> favouriteHandleDelegate;

//IBActions
- (IBAction)favoriteButtonPressed:(UIButton *)sender;


@end
