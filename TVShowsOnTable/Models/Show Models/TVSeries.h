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

/**
 Episode of tv series
 */
@property (strong, nonatomic) NSString *tvSeriesEpisode;

/**
 Tv series summary
 */
@property (strong, nonatomic) NSString *tvSeriesSummary;

#pragma mark -initialisers

/**
 TVSeries object initialisation

 @param seriesEpisode Tv series episode
 @param summary Tv series summary
 @param showObject An object of type Show
 @return TVSeries object initialised
 */
- (instancetype)initWithEpisode:(NSString *)seriesEpisode
                     andSummary:(NSString *)summary
                  andShowObject:(Show *)showObject;

/**
 TVSeries object initialisation

 @param episodeName The name of tv series' episode
 @param episodeSummary The summary of tv series' episode
 @return TVSeries object initialised
 */
- (instancetype)initWithEpisodeName:(NSString *)episodeName
                  andEpisodeSummary:(NSString *)episodeSummary;

/**
 TVSeries object initialisation, written to work with the movie db REST APi

 @param dict Dictionary
 @return TVSeries object initialised
 */
- (instancetype)initWithDictionaryForTvDbAPI:(NSDictionary *)dict;

/**
 Private property summary getter

 @return The value of summary
 */
- (NSString *)getSummary;

@end
