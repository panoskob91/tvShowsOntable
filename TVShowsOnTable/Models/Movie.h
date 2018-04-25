//
//  Movie.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"

@interface Movie : Show

@property (strong, nonatomic) NSString *movie;
//@property (strong, nonatomic) NSString *summary;


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
