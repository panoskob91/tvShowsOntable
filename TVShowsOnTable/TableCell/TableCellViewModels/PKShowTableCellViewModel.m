//
//  PKShowTableCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKShowTableCellViewModel.h"

@implementation PKShowTableCellViewModel

#pragma mark -Initialisers
- (instancetype)initWithShowViewModelObject:(Show *)showObject
{
    self = [super init];
    
    if (self)
    {
        self.showViewModelTitle = showObject.showTitle;
        self.showViewModelImageURL = showObject.showImageUrlPath;
        if (![showObject.showAverageRating isEqual:(NSNumber *)@""])
        {
            self.showViewModelAverageRating = [NSString stringWithFormat:@"%@/10", showObject.showAverageRating];
        }
        else
        {
            self.showViewModelAverageRating = [NSString stringWithFormat:@"%@", showObject.showAverageRating];
        }
        self.bindModel = showObject;
        
    }
    return self;
}

- (instancetype)initWithShowViewModelObject:(Show *)showObject
                         andShowGroupObject:(AFSEShowGroup *)showGroupObject
{
    self = [self initWithShowViewModelObject:showObject];
    //self = [super init];
    
    if (self)
    {
        self.showGroup = showGroupObject;
        
    }
    return self;
}

- (NSString *)getCellIdentifier
{
 return @"tVShowsCell";
}

- (void)updateView:(TVShowsCell *)cell
{
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
    
    if ([self.bindModel.mediaType isEqualToString:@"tv"])
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
    }
    else if ([self.bindModel.mediaType isEqualToString:@"movie"])
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
    }
    
}

@end
