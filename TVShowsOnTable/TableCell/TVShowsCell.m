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
   
    self.TVShowsImage.layer.cornerRadius = 5;
    self.TVShowsImage.clipsToBounds = YES;
    self.showsTitleDescription.numberOfLines = 2;
    self.showTitleLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void) setupCellPropertiesWithObject:(Show *)Object
{
    self.showTitleLabel.text = Object.showTitle;
    
    NSURL *imageURL = [NSURL URLWithString:Object.showImage];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    self.TVShowsImage.image = [UIImage imageWithData:imageData];
    
    //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
    self.averageRating.text = [NSString stringWithFormat:@"%@", Object.showAverageRating];
    
    
}

@end
