//
//  PKSummaryCellDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKSummaryCellDetailsVC.h"
#import "UIColor+rgb.h"

//Categories
#import "UIAlertController+AFSEAlertGenerator.h"

//Sigleton
#import "Session.h"

@interface PKSummaryCellDetailsVC ()

@property (assign, nonatomic) BOOL isPressed;

@end

@implementation PKSummaryCellDetailsVC

#pragma mark - Style cell outlets

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailsCellDescriptionLabel.textColor = [UIColor blackColor];
    self.detailsCellDescriptionLabel.font = [UIFont fontWithName:@"TimeBurner" size:17];
    self.detailsCellDescriptionLabel.textColor = [UIColor createColorWithRed:0
                                                                    andGreen:0
                                                                     andBlue:0
                                                                    andAlpha:1];
    
    self.detailsCellTextView.textColor = [UIColor blackColor];
    self.detailsCellTextView.backgroundColor = [UIColor redColor];
    self.detailsCellDescriptionLabel.userInteractionEnabled = YES;
    
    self.isPressed = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)favoriteButtonPressed:(UIButton *)sender {
    UIImage *buttonImage = [[UIImage alloc] init];
    if (self.isPressed)
    {
        //Add Show to list.movies array
        buttonImage = [UIImage imageNamed:@"filled-star"];
        self.isPressed = NO;
    }
    else
    {
        //Remove show from list.movies array
        buttonImage = [UIImage imageNamed:@"empty-star"];
        self.isPressed = YES;
    }
    [self.favoritesButton setImage:buttonImage forState:UIControlStateNormal];
}
@end
