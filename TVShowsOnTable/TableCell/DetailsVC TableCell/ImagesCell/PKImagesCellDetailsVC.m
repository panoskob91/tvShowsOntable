//
//  PKImagesCellDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKImagesCellDetailsVC.h"

@implementation PKImagesCellDetailsVC

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImageDetailsVC.layer.cornerRadius = 10;
    self.mainImageDetailsVC.clipsToBounds = YES;
    self.mediaTypeImageIndicator.layer.cornerRadius = 10;
    self.mediaTypeImageIndicator.clipsToBounds = YES;
    self.ratingLabel.font = [UIFont fontWithName:@"TimeBurner" size:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
