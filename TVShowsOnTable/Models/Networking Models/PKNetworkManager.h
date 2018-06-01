//
//  AFSENetworking.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 07/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSENetworkingDelegate.h"
#import "Favorite.h"
#import "Show.h"

#define THE_MOVIE_DB_API_KEY @"6b2e856adafcc7be98bdf0d8b076851c"

@interface PKNetworkManager : NSObject

@property (strong, nonatomic) NSArray<Favorite *> *list;

/**
 The object responsible for networking delegation
 */
@property (nonatomic, weak) id <AFSENetworkingDelegate> networkingDelegate;

/**
 Array of Show type objects
 */
@property (strong, nonatomic) NSMutableArray<Show *> *shows;

/**
 The youtube key needed for the youtube video playback
 */
@property (strong, nonatomic) NSString *youtubeKey;


/**
 The movie db RESTfull API fething function. It appends API properties to an NSArray with Show type elements, which is passed then, with delegation, to the corresponding class.

 @param searchText Uers's input text.
 */
-(void)fetchAPICallWithSearchText:(NSString *)searchText;

/**
 Description fetching  function. The movie db API is fetched for this purpose.

 @param showId The showID property of Show model objects
 @param mediaType The mediaType property of Show model objects
 */
-(void)fetchDescriptionFromId:(NSNumber *)showId
                  andMediaType:(ShowType)mediaType;

/**
 Function fetching youtube key, for video trailer playback

 @param showId The showID property of Show type objects
 @param mediaType The mediaType property of Show type objects
 */
-(void)getYoutubeVideoKeyWithShowID:(NSNumber *)showId
                       andMediaType:(ShowType)mediaType;

- (void)getGenreNameAndIDSWithCompletionBlock:(void(^)(NSDictionary *dictionary))sBlock;

@end
