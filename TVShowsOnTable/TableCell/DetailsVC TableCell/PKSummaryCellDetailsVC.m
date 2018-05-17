//
//  PKSummaryCellDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKSummaryCellDetailsVC.h"

@implementation PKSummaryCellDetailsVC

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.detailTextLabel.numberOfLines = 0;
    self.detailsCellDescriptionLabel.textColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
