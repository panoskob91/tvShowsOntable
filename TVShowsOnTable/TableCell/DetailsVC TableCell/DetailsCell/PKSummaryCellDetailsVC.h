//
//  PKSummaryCellDetailsVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShowsCell.h"

@interface PKSummaryCellDetailsVC : TVShowsCell

@property (strong, nonatomic) IBOutlet UILabel *detailsCellDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailsCellTextView;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;


@end
