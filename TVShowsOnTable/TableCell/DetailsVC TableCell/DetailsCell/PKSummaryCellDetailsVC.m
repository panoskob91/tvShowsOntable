//
//  PKSummaryCellDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKSummaryCellDetailsVC.h"
#import "UIColor+rgb.h"

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

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
//    self.detailsCellBackgroundView.tag = 1;
//    [tap setNumberOfTapsRequired:1];
//    [self.detailsCellBackgroundView addGestureRecognizer:tap];
    
    self.isPressed = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)viewWasTapped:(UITapGestureRecognizer *)tap
{
    NSLog(@"tapped");
    if (self.isPressed)
    {
        //Add show to list.movies array
        self.isPressed = NO;
    }
    else
    {
        //Remove show from list.movies array
        self.isPressed = YES;
    }
}


- (IBAction)favoriteButtonPressed:(UIButton *)sender {
    NSLog(@"Pressed");
}
@end
