//
//  TVSeries.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "TVSeries.h"

@implementation TVSeries

- (instancetype)initWithEpisode:(NSString *)seriesEpisode
                     andSummary:(NSString *)summary
                  andShowObject:(Show *)showObject
{
    
    self = [super init];
    
    if (self)
    {
        self.tvSeriesEpisode = seriesEpisode;
        self.tvSeriesSummary = summary;
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        self.showAverageRating = showObject.showAverageRating;
    }
    
    return self;
}

- (instancetype)initWithEpisodeName:(NSString *)episodeName
                  andEpisodeSummary:(NSString *)episodeSummary
{
    self = [super init];
    
    if (self)
    {
        self.tvSeriesEpisode = episodeName;
        self.tvSeriesSummary = episodeSummary;
    }
    
    return self;
}

- (instancetype)initWithDictionaryForTvDbAPI:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        self = [super initWithDictionaryForTvDb:dict];
    }
    return self;
}

- (NSString *)getSummary
{
    return self.tvSeriesSummary;
}

@end
