//
//  PKTableViewCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKTVTableViewCellViewModel.h"

@implementation PKTVSeriesViewModel

- (instancetype)initWithTVSeriesModel:(TVSeries *)tvSeriesModel
{
    self = [super init];
    
    if (self)
    {
        self.bindModel = tvSeriesModel;
        self.tvSeriesTitle = tvSeriesModel.showTitle;
        self.tvSeriesRating = [NSString stringWithFormat:@"%@/10", tvSeriesModel.showAverageRating];
    }
    return self;
}

- (NSString *)cellIdentifier
{
    return @"tVShowsCell";
}

- (void)updateView:(TVShowsCell *)cell
{
    cell.showTitleLabel.text = self.tvSeriesTitle;
    
//    NSURL *imageURL = [NSURL URLWithString:Object.showImageUrlPath];
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    //cell.tvShowsImage.image = [UIImage imageWithData:imageData];
    cell.showAverageRatingLabel.text = self.tvSeriesRating;
}

@end
