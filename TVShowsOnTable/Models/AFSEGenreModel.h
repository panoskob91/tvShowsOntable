//
//  AFSEGenreModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFSEGenreModel : NSObject


/**
 Show genre Id, as provided by The movie db API
 */
@property (strong, nonatomic) NSNumber *genreID;

/**
 Show genre name
 */
@property (strong, nonatomic) NSString *genreName;



/**
 Class initialiser

 @param GID Genre ID
 @param name Genre name
 @return Initialised AFSEGenreModel object
 */
- (instancetype)initWithGenreID:(NSNumber *)GID
                   andGenreName:(NSString *)name;

@end
