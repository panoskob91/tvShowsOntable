//
//  AFSEGenreModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFSEGenreModel : NSObject

@property (strong, nonatomic) NSNumber *genreID;
@property (strong, nonatomic) NSString *genreName;

-(instancetype) initWithGenreID: (NSNumber *)GID
                   andGenreName: (NSString *)name;

@end
