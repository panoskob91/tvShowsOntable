//
//  Movie.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Movie.h"

@implementation Movie

#pragma mark -Initialisers
- (instancetype)initWithMovie: (NSString *)movieName
                     andSummary:(NSString *)movieSummary
                  andShowObject:(Show *)showObject
{
    
    self = [super init];
    
    if (self)
    {
        self.movie = movieName;
        self.summary = movieSummary;
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        
    }
    
    return self;
    
}

- (NSString *)getSummary
{
    return self.summary;
}

@end
