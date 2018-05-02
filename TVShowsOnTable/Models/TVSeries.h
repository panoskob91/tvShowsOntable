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

@property (strong, nonatomic) NSString *episode;
@property (strong, nonatomic) NSString *summary;

//#pragma mark -TV Genre enum
//enum TvGenre {
//
//    TVActionAndAdventure = 10759,
//    TVAnimation = 16,
//    TVComedy = 35,
//    TVCrime = 80,
//    TVDocumentary = 99,
//    TVDrama = 18,
//    TVFamily = 10751,
//    TVKids = 10762,
//    TVMystery = 9648,
//    TVNews = 10763,
//    TVReality = 10764,
//    TVSciFiAndFantasy = 10765,
//    TVSoap = 10766,
//    TVTalk = 10767,
//    TVWarAndPolitics = 10768,
//    TVWestern = 37
//
//};

#pragma mark -initialisers
- (instancetype)initWithEpisode: (NSString *)seriesEpisode
                     andSummary: (NSString *)summary
                  andShowObject: (Show *)showObject;

- (instancetype)initWithEpisodeName: (NSString *)episodeName
                  andEpisodeSummary: (NSString *)episodeSummary;

- (instancetype)initWithDictionaryForTvDbAPI: (NSDictionary *)dict;

- (NSString *)getSummary;

@end
