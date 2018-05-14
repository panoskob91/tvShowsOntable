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
{
    self = [super init];
    
    if (self)
    {
        self.showSumary = [(Movie *)showObject getSummary];
        self.imageUrlPath = showObject.showImageUrlPath;
        if ([showObject.mediaType isEqualToString:@"movie"])
        {
            self.showTypeImageName = @"movieImage";
        }
        else if ([showObject.mediaType isEqualToString:@"tv"])
        {
            self.showTypeImageName = @"TvSeries";
        }
    }
    return self;
}

- (void)setupImageViewsFromVC:(DetailsViewController *)detailsVC WithObject:(PKDetailsVCViewModel *)viewModelObject
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:viewModelObject.imageUrlPath]];
    detailsVC.showImageView.image = [UIImage imageWithData:imageData];
    
    detailsVC.showImageView.layer.cornerRadius = 10;
    detailsVC.showImageView.contentMode = UIViewContentModeScaleToFill;
    detailsVC.showImageView.clipsToBounds = YES;
    detailsVC.mediaTypeImageView.image = [UIImage imageNamed:self.showTypeImageName];
}

- (void)setupDetailsTextViewFromVC:(DetailsViewController *)detailsVC WithString:(NSString *)showSummary
{
    detailsVC.descriptionDetailsTextView.text = showSummary;
    detailsVC.descriptionDetailsTextView.editable = NO;
    [detailsVC.descriptionDetailsTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    detailsVC.descriptionDetailsTextView.textColor = [UIColor blackColor];
}

@end
