//
//  PKShowTableCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKShowTableCellViewModel.h"

@implementation PKShowTableCellViewModel

- (instancetype)initWithShowViewModelObject:(Show *)showObject
{
    self = [super init];
    
    if (self)
    {
        self.showViewModelTitle = showObject.showTitle;
        self.showViewModelImageURL = showObject.showImageUrlPath;
        if (![showObject.showAverageRating isEqual:(NSNumber *)@""])
        {
            self.showViewModelAveragerating = [NSString stringWithFormat:@"%@/10", showObject.showAverageRating];
        }
        else
        {
            self.showViewModelAveragerating = [NSString stringWithFormat:@"%@", showObject.showAverageRating];
        }
        
        
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
    if (![self.showViewModelAveragerating isEqualToString:@""])
    {
        cell.showAverageRatingLabel.text = self.showViewModelAveragerating;
    }
    else
    {
        cell.showAverageRatingLabel.text = @"";
    }
    
}

@end
