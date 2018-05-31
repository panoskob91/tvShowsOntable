//
//  PKDetailsImagesCellVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsImagesCellVM.h"

@implementation PKDetailsImagesCellVM

#pragma mark - Initialiser
- (instancetype)initWithMainImageURLPath:(NSString *)mainImageURL
                           andShowObject:(Show *)showObject
                 andRatingImageNameArray:(NSArray<NSString *> *)ratingImageNames
{
    self = [super init];
    
    if (self)
    {
        self.mainImageUrlPath = mainImageURL;
        if (showObject.mediaType == ShowTypeMovie)
        {
            self.mediaTypeIndicatorImageName = @"movieImage";
        }
        else if (showObject.mediaType == ShowTypeTVSeries)
        {
            self.mediaTypeIndicatorImageName = @"TvSeries";
        }
        self.ratingImageIndicatorNames = ratingImageNames;
        self.bindModel = (Show *)showObject;
    }
    
    return self;
}
#pragma mark - Getters
- (NSString *)getCellIdentifier
{
    return @"detailsVCimagesCell";
}
#pragma mark - Update functions
//Function for drawing cells
- (void)updateView:(PKImagesCellDetailsVC *)cell
{
    NSURL *mainImageURL = [NSURL URLWithString:self.mainImageUrlPath];
    NSData *mainImageData = [NSData dataWithContentsOfURL:mainImageURL];
    
    cell.mainImageDetailsVC.image = [UIImage imageWithData:mainImageData];
    cell.mediaTypeImageIndicator.image = [UIImage imageNamed:self.mediaTypeIndicatorImageName];
    
    cell.ratingImage0.image = [UIImage imageNamed:self.ratingImageIndicatorNames[0]];
    cell.ratingImage1.image = [UIImage imageNamed:self.ratingImageIndicatorNames[1]];
    cell.ratingImage2.image = [UIImage imageNamed:self.ratingImageIndicatorNames[2]];
    cell.ratingImage3.image = [UIImage imageNamed:self.ratingImageIndicatorNames[3]];
    cell.ratingImage4.image = [UIImage imageNamed:self.ratingImageIndicatorNames[4]];
    
}

@end
