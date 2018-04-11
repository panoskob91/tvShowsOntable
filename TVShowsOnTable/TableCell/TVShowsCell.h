//
//  TVShowsCell.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVShowsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *TVShowsImage;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showsTitleDescription;
@property (weak, nonatomic) IBOutlet UILabel *averageRating;

@end
