//
//  TVShowsCell.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "TVShowsCell.h"
#import "Movie.h"
#import "TVSeries.h"
#import "FavoritesHandlingDelegate.h"

@interface TVShowsCell ()

@property (assign, nonatomic) BOOL isPressed;

@end


@implementation TVShowsCell

#pragma mark - Cell outlets style

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.tvShowsImage.layer.cornerRadius = 5;
    self.tvShowsImage.clipsToBounds = YES;
    self.showsTitleDescription.numberOfLines = 2;
    self.showTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.showTitleLabel.numberOfLines = 0;
    //self.showTitleLabel.font = [UIFont fontWithName:@"MJ Granada" size:13];
    self.showTitleLabel.font = [UIFont fontWithName:@"ADAM.CG PRO" size:20];
    [self.favoriteButton setImage:[UIImage imageNamed:@"empty-star"] forState:UIControlStateNormal];
    self.isPressed = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setupCellPropertiesWithObject:(Show *)Object
{
    self.showTitleLabel.text = Object.showTitle;
    
    NSURL *imageURL = [NSURL URLWithString:Object.showImageUrlPath];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];

    self.tvShowsImage.image = [UIImage imageWithData:imageData];
    self.showAverageRatingLabel.text = [NSString stringWithFormat:@"%@", Object.showAverageRating];    
}

- (IBAction)favouriteUnfavouriteButtonPressed:(UIButton *)sender
{
    UIImage *favouriteButtonImage = [[UIImage alloc] init];
    if (self.isPressed)
    {
        //Add show to session singleton
        //TODO: Add show to session singleton
        [self.favouriteHandlingDelegate addButtonWasPressedFromCell:self];
        favouriteButtonImage = [UIImage imageNamed:@"filled-star"];
        self.isPressed = NO;
    }
    else
    {
        //Remove show from session singleton
        //TODO: Remove show from session singleton
        [self.favouriteHandlingDelegate removeButtonWasPressedFromCell:self];
        favouriteButtonImage = [UIImage imageNamed:@"empty-star"];
        self.isPressed = YES;
        
    }
    //[self.favoriteButton setImage:favouriteButtonImage forState:UIControlStateNormal];
}
@end
