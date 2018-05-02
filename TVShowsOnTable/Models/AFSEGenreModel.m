//
//  AFSEGenreModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSEGenreModel.h"

@implementation AFSEGenreModel

-(instancetype) initWithGenreID:(NSNumber *)GID
                   andGenreName:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        self.genreID = GID;
        self.genreName = name;
    }
    return self;
}

@end
