//
//  Show.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ShowTypeMovie,
    ShowTypeTVSeries
}ShowType;

@interface Show : NSObject

#pragma mark -Class Properties

/**
 Show's title
 */
@property (strong, nonatomic) NSString *showTitle;

/**
 show's image url path
 */
@property (strong, nonatomic) NSString *showImageUrlPath;


/**
 Backdrop image url
 */
@property (strong, nonatomic) NSString *showBackdropImageURLPath;

/**
 Show's average rating
 */
@property (strong, nonatomic) NSNumber *showAverageRating;

/**
 Show's genre ID
 */
@property (strong, nonatomic) NSNumber *showGenreID;

/**
 Show's media type
 */
//@property (strong, nonatomic) NSString *mediaType;

@property (nonatomic) ShowType mediaType;

#pragma mark -Initialisers

/**
 Object initialiser

 @param ST Show's title
 @param SI Show's image path url
 @param SAR Show's average rating
 @return Initialised Show object
 */
- (instancetype)initWithTitle: (NSString *)ST
                     andImage: (NSString *)SI
             andAverageRating: (NSNumber *)SAR;

/**
 Object initialiser

 @param dict Input dictionary
 @return Initialised Show object
 */
- (instancetype)initWithDictionary: (NSDictionary *)dict;

/**
 Object initialiser, written to work with the movie db RESTfull API

 @param dict Dictionary
 @return Initialised Show object
 */
//dictionary, which is passed as an argument must be inside results key of API response
- (instancetype)initWithDictionaryForTvDb: (NSDictionary *)dict;

#pragma mark -Private properties getters

/**
 Private showId property getter

 @return Show's showId property
 */
- (NSNumber *)getShowId;

@end
