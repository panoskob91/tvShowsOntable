//
//  Favorite.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 01/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "List.h"

@implementation List

- (instancetype)initWithName:(NSString *)name
              andMoviesArray:(NSMutableArray<Show *> *)movies
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.movies = movies;
    }
    return self;
}
- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.movies = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
