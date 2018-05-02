//
//  Movie.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

//Parent class
#import "Show.h"

@interface Movie : Show

@property (strong, nonatomic) NSString *movie;
//@property (strong, nonatomic) NSString *summary;

//#pragma mark -MovieGenre enum
//enum MovieGenre
//{
//    
//    MVAction = 28,
//    MVAdventure = 12,
//    MVAnimation = 16,
//    MVComedy = 35,
//    MVCrime = 80,
//    MVDocumentary = 99,
//    MVDrama = 18,
//    MVFamily = 10751,
//    MVFantasy = 14,
//    MVHistory = 36,
//    MVHorror = 27,
//    MVMusic = 10402,
//    MVMystery = 9648,
//    MVRomance = 10749,
//    MVScience_Fiction = 878,
//    MVTV_Movie = 10770,
//    MVThriller = 53,
//    MVWar = 10752,
//    MVWestern = 37
//    
//};

#pragma mark -Initialisers
- (instancetype) initWithMovie: (NSString *)movieName
                   andSummary:(NSString *)movieSummary
                andShowObject:(Show *)showObject;

- (instancetype) initWithDictionary: (NSDictionary *)dict
                      andShowObject: (Show *)showObject;

//Must be inside results
- (instancetype) initWithDictionaryFromTvDb: (NSDictionary *)dict
                              andShowObject: (Show *)showObject;

- (instancetype) initWithResponseDictionaryFromTvDb: (NSDictionary *)dict;

- (instancetype) initWithMovieName: (NSString *)movieName
                   andMovieSummary: (NSString *)movieSummary;
#pragma mark -Getters
- (NSString *)getSummary;
- (NSNumber *)getShowId;

@end
