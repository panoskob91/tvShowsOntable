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

@implementation TVShowsCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.tvShowsImage.layer.cornerRadius = 5;
    self.tvShowsImage.clipsToBounds = YES;
    self.showsTitleDescription.numberOfLines = 2;
    self.showTitleLabel.adjustsFontSizeToFitWidth = YES;
    
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

@end
