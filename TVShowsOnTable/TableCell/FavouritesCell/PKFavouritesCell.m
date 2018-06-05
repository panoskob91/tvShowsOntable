//
//  PKFavouritesCell.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKFavouritesCell.h"
//Singleton
#import "Session.h"


@implementation PKFavouritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)favoriteUnfavoriteShowWasPressed:(UIButton *)sender {
    //Remove Entry
    //[self.favoritesHandlingDelegate removeButtonWasPressedFromCell:self];
}
@end
