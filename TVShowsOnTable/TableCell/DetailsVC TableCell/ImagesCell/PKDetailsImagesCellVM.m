//
//  PKDetailsImagesCellVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsImagesCellVM.h"

@implementation PKDetailsImagesCellVM

#pragma mark -Initialiser
- (instancetype)initWithMainImageURLPath:(NSString *)mainImageURL
                           andShowObject:(Show *)showObject
                 //andRatingImageNameArray:(NSArray<NSString *> *)ratingImageNames
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
        //self.ratingImageIndicatorNames = ratingImageNames
        self.bindModel = (Show *)showObject;
    }
    
    return self;
}

- (NSString *)getCellIdentifier
{
    return @"detailsVCimagesCell";
}

- (void)updateView:(PKImagesCellDetailsVC *)cell
{
    NSURL *mainImageURL = [NSURL URLWithString:self.mainImageUrlPath];
    NSData *mainImageData = [NSData dataWithContentsOfURL:mainImageURL];
    
    cell.mainImageDetailsVC.image = [UIImage imageWithData:mainImageData];
    cell.mediaTypeImageIndicator.image = [UIImage imageNamed:self.mediaTypeIndicatorImageName];
}

@end
