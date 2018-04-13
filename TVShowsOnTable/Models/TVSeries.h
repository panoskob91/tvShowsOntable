//
//  TVSeries.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"

@interface TVSeries : Show

@property (strong, nonatomic) NSString *episode;
@property (strong, nonatomic) NSString *summary;

- (NSString *)getSummary;

@end
