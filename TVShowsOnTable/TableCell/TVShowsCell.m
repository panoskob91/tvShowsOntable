//
//  TVShowsCell.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "TVShowsCell.h"

@implementation TVShowsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.TVShowsImage.layer.cornerRadius = 5;
    self.TVShowsImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
