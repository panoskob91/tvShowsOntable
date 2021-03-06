//
//  TVSeries.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "TVSeries.h"

@implementation TVSeries

- (instancetype)initWithEpisode: (NSString *)seriesEpisode
                     andSummary: (NSString *)summary
                  andShowObject: (Show *)showObject
{
    
    self = [super init];
    
    if (self)
    {
        self.episode = seriesEpisode;
        self.summary = summary;
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        self.showAverageRating = showObject.showAverageRating;
    }
    
    return self;
}

- (instancetype)initWithEpisodeName: (NSString *)episodeName
                  andEpisodeSummary: (NSString *)episodeSummary
{
    self = [super init];
    
    if (self)
    {
        self.episode = episodeName;
        self.summary = episodeSummary;
    }
    
    return self;
}

- (NSString *)getSummary
{
    return self.summary;
}

@end
