//
//  PKShowTableCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKShowTableCellViewModel.h"
#import "Session.h"

@implementation PKShowTableCellViewModel

#pragma mark -Initialisers

- (instancetype)initWIthTitle:(NSString *)title
                  andImageURL:(NSString *)url
             andAverageRating:(NSString *)avgRating
                   andGenreID:(NSNumber *)genreID
                 andBindModel:(id)bindModel
{
    self = [super init];
    
    if (self)
    {
        self.showViewModelTitle = title;
        self.showViewModelImageURL = url;
        self.showViewModelAverageRating = avgRating;
        self.showViewModelGenreID = genreID;
        self.bindModel = (Show *)bindModel;
        
    }
    return self;
}

- (instancetype)initShowViewModelWithGenreID:(NSNumber *)genreID
{
    self = [super init];
    if (self)
    {
        self.showViewModelGenreID = genreID;
        self.showViewModelList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithShowViewModelObject:(Show *)showObject
{
    NSString *averageRating = [NSString stringWithFormat:@"%@/10", showObject.showAverageRating];
    self = [self initWIthTitle:showObject.showTitle
                   andImageURL:showObject.showImageUrlPath
              andAverageRating:averageRating
                    andGenreID:showObject.showGenreID
                  andBindModel:showObject];
    
    if (self)
    {
        self.showViewModelList = [[NSMutableArray alloc] init];
        self.showViewModelGenreName = [[NSString alloc] init];
        
        if (showObject.isFavourite)
        {
            self.favouritesImageName = @"filled-star";
        }
        else
        {
            self.favouritesImageName = @"empty-star";
        }
    }
    return self;
}

- (instancetype)initWithBindModel:(id)bindModel
{
    self = [super init];
    if (self)
    {
        self.bindModel = (Show *)bindModel;
    }
    return self;
}

#pragma mark -Class Methods

- (NSString *)getCellIdentifier
{
 return @"tVShowsCell";
}

- (void)updateView:(TVShowsCell *)cell
{
    cell.favouriteHandlingDelegate = self;
    cell.showTitleLabel.text = self.showViewModelTitle;
    
        NSURL *imageURL = [NSURL URLWithString:self.showViewModelImageURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    cell.tvShowsImage.image = [UIImage imageWithData:imageData];
    if (![self.showViewModelAverageRating isEqualToString:@""])
    {
        cell.showAverageRatingLabel.text = self.showViewModelAverageRating;
    }
    else
    {
        cell.showAverageRatingLabel.text = @"";
    }
    if (self.bindModel.mediaType == ShowTypeTVSeries)
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
    }
    else if (self.bindModel.mediaType == ShowTypeMovie)
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
    }
    
    if (self.bindModel.isFavourite)
    {
        self.favouritesImageName = @"filled-star";
    }
    else
    {
        self.favouritesImageName = @"empty-star";
    }
    [cell.favoriteButton setImage:[UIImage imageNamed:self.favouritesImageName] forState:UIControlStateNormal];
}

- (void)addButtonWasPressedFromCell:(TVShowsCell *)cell
{
    //Add show object to singleton
    Session *session = [Session sharedSession];
    [session.favorite.movies addObject:self.bindModel];
    self.bindModel.isFavourite = YES;
    [self updateView:cell];
}

- (void)removeButtonWasPressedFromCell:(TVShowsCell *)cell
{
    //Remove Show object from singleton
    Session *session = [Session sharedSession];
    [session.favorite.movies removeObject:self.bindModel];
    self.bindModel.isFavourite = NO;
    [self updateView:cell];
}

@end
