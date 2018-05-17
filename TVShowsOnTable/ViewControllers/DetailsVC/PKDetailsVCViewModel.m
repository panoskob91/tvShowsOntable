//
//  PKDetailsVCViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsVCViewModel.h"
#import "DetailsViewController.h"
#import "Movie.h"

@implementation PKDetailsVCViewModel

- (instancetype)initWithObject:(Show *)showObject
                andShowSummary:(NSString *)showSummary
{
    self = [super init];
    
    if (self)
    {
        self.showSumary = showSummary;
        self.imageUrlPath = showObject.showImageUrlPath;
        if (showObject.mediaType == ShowTypeMovie)
        {
            self.showTypeImageName = @"movieImage";
        }
        else if (showObject.mediaType == ShowTypeTVSeries)
        {
            self.showTypeImageName = @"TvSeries";
        }
    }
    return self;
}

- (void)setupImageViewsFromVC:(DetailsViewController *)detailsVC
                   WithObject:(PKDetailsVCViewModel *)viewModelObject
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:viewModelObject.imageUrlPath]];
    detailsVC.showImageView.image = [UIImage imageWithData:imageData];
    
    detailsVC.showImageView.layer.cornerRadius = 10;
    detailsVC.showImageView.contentMode = UIViewContentModeScaleToFill;
    detailsVC.showImageView.clipsToBounds = YES;
    detailsVC.mediaTypeImageView.image = [UIImage imageNamed:self.showTypeImageName];
}

- (void)setupDetailsTextViewFromVC:(DetailsViewController *)detailsVC
                        WithString:(NSString *)showSummary
{
    detailsVC.descriptionDetailsTextView.text = showSummary;
    detailsVC.descriptionDetailsTextView.editable = NO;
    [detailsVC.descriptionDetailsTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    detailsVC.descriptionDetailsTextView.textColor = [UIColor blackColor];
}

#pragma mark -Cell functions
- (NSString *)getDetailsImagesCellIdentifier
{
    return @"detailsVCimagesCell";
}

- (NSString *)getDetailsSummaryCellIdentifier
{
    return @"detailsVCDetailsCell";
}
- (void)updateImagesCell:(PKImagesCellDetailsVC *)cell
{
    NSURL *imageURL = [NSURL URLWithString:self.imageUrlPath];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.mainImageDetailsVC.image = [UIImage imageWithData:imageData];
    cell.mediaTypeImageIndicator.image = [UIImage imageNamed:self.showTypeImageName];
}

- (void)updateDetailsCell:(PKSummaryCellDetailsVC *)cell
{
    cell.detailsCellDescriptionLabel.text = self.showSumary;
}

#pragma mark -Image indicator based on media type
- (NSString *)getMediaTypeImageIndicatorNameFromObject:(Show *)showObject
{
    NSString *imageName = [[NSString alloc] init];
    if (showObject.mediaType == ShowTypeTVSeries)
    {
        imageName = @"TvSeries";
    }
    else if (showObject.mediaType == ShowTypeMovie)
    {
        imageName = @"movieImage";
    }
    return imageName;
}

@end
