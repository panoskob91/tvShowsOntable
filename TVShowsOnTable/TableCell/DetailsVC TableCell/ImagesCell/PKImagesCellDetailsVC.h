//
//  PKImagesCellDetailsVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShowsCell.h"

@interface PKImagesCellDetailsVC : TVShowsCell

@property (strong, nonatomic) IBOutlet UIImageView *mainImageDetailsVC;
@property (strong, nonatomic) IBOutlet UIImageView *mediaTypeImageIndicator;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

//Rating Images
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage0;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage1;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage2;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage3;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage4;

@end
