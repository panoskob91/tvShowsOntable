//
//  PKTableViewCellViewModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVSeries.h"
#import "TVShowsCell.h"

@interface PKTVSeriesViewModel : NSObject

@property (strong, nonatomic) TVSeries *bindModel;

@property (strong, nonatomic) NSString *tvSeriesTitle;
@property (strong, nonatomic) NSString *tvSeriesRating;

- (instancetype)initWithTVSeriesModel:(TVSeries *) tvSeriesModel;

- (NSString *)cellIdentifier;
- (void)updateView:(TVShowsCell *)cell;

@end
