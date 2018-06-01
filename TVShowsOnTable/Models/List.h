//
//  Favorite.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 01/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Show.h"
@interface List : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray<Show *> *movies;

- (instancetype)initWithName:(NSString *)name
              andMoviesArray:(NSMutableArray<Show *> *)movies;

- (instancetype)initWithName:(NSString *)name;

@end
