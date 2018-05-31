//
//  PKSummaryCellDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKSummaryCellDetailsVC.h"
#import "UIColor+rgb.h"

@implementation PKSummaryCellDetailsVC
#pragma mark - Style cell outlets
- (void)awakeFromNib {
    [super awakeFromNib];
    //self.detailTextLabel.numberOfLines = 0;
    self.detailsCellDescriptionLabel.textColor = [UIColor blackColor];
    //self.detailsCellDescriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    self.detailsCellDescriptionLabel.font = [UIFont fontWithName:@"TimeBurner" size:17];
    self.detailsCellDescriptionLabel.textColor = [UIColor createColorWithRed:0
                                                                    andGreen:0
                                                                     andBlue:0
                                                                    andAlpha:1];
    self.detailsCellTextView.textColor = [UIColor blackColor];
    self.detailsCellTextView.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
