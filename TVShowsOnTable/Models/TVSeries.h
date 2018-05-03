//
//  TVSeries.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

//Parent class
#import "Show.h"

@interface TVSeries : Show

@property (strong, nonatomic) NSString *tvSeriesEpisode;
@property (strong, nonatomic) NSString *tvSeriesSummary;

#pragma mark -initialisers
- (instancetype)initWithEpisode:(NSString *)seriesEpisode
                     andSummary:(NSString *)summary
                  andShowObject:(Show *)showObject;

- (instancetype)initWithEpisodeName:(NSString *)episodeName
                  andEpisodeSummary:(NSString *)episodeSummary;

- (instancetype)initWithDictionaryForTvDbAPI:(NSDictionary *)dict;

- (NSString *)getSummary;

@end
