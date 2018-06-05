//
//  PKFavouritesCellVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKFavouritesCellVM.h"

@implementation PKFavouritesCellVM

- (instancetype)initWithFavouriteShowTitle:(NSString *)title
                           andMainImageURL:(NSString *)mainImgURL
                andMediaType:(ShowType)mediaType
                      andFavoriteImageName:(NSString *)favouriteImageName
                              andBindModel:(id)bindModel
{
    self = [super init];
    if (self)
    {
        self.favouriteShowTitle = title;
        self.mainImageURL = mainImgURL;
        if (mediaType == ShowTypeMovie)
        {
            self.mediaTypeImageIndicatorName = @"movieImage";
        }
        else if (mediaType == ShowTypeTVSeries)
        {
            self.mediaTypeImageIndicatorName = @"TvSeries";
        }
        self.favoriteImageName = favouriteImageName;
        self.bindModel = bindModel;
    }
    return self;
}

- (NSString *)getCellIdentifier
{
    return @"favouritesCell";
}

- (void)updateView:(PKFavouritesCell *)favouritesCell
{
    NSURL *mainImageURL = [NSURL URLWithString:self.mainImageURL];
    NSData *mainImageData = [NSData dataWithContentsOfURL:mainImageURL];
    
    favouritesCell.favouriteShowMainImage.image = [UIImage imageWithData:mainImageData];
    favouritesCell.favouriteShowTitle.text = self.favouriteShowTitle;
    favouritesCell.favoriteShowMediaTypeImageIndicator.image = [UIImage imageNamed:self.mediaTypeImageIndicatorName];
    [favouritesCell.favoriteUnfavoriteButton setImage:[UIImage imageNamed:self.favoriteImageName] forState:UIControlStateNormal];

}

@end
