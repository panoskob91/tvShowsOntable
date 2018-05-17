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

/**
 Movie title property
 */
@property (strong, nonatomic) NSString *movieTitle;

#pragma mark -Initialisers
/**
 Object initialiser

 @param movieName The movie's name
 @param movieSummary The movie's summary
 @param showObject An object of type Show
 @return Initialised movie object
 */
- (instancetype)initWithMovie: (NSString *)movieName
                   andSummary:(NSString *)movieSummary
                andShowObject:(Show *)showObject;

/**
 Object initialiser written to work with TvMaze RESTfull API

 @param dict Dictionary
 @param showObject An object of type Show
 @return Initialised movie object
 */
- (instancetype)initWithDictionary: (NSDictionary *)dict
                     andShowObject: (Show *)showObject;

/**
 Object initialiser written to work with the movie db RESTfull API

 @param dict Dictionary
 @param showObject Object of type Show
 @return Initialised movie object
 */
//dict must be inside results
- (instancetype)initWithDictionaryFromTvDb: (NSDictionary *)dict
                             andShowObject: (Show *)showObject;

/**
 Object initialiser written to work with the movie db RESTfull API

 @param dict Dictionary
 @return Initialised movie object
 */
- (instancetype)initWithResponseDictionaryFromTvDb: (NSDictionary *)dict;

/**
  Object initialiser

 @param movieName The value of the movieTitle property
 @param movieSummary The value of the private property summary
 @return Initialised movie object
 */
- (instancetype)initWithMovieName: (NSString *)movieName
                  andMovieSummary: (NSString *)movieSummary;
#pragma mark -Getters
- (NSString *)getSummary;
- (NSNumber *)getShowId;
@end
