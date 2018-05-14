//
//  PKMovieCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKMovieCellViewModel.h"

@implementation PKMovieCellViewModel

- (instancetype)initWithMovieModel:(Movie *)movieObject
{
    self = [super init];
    
    if (self) {
        self.bindModel = movieObject;
        
        self.movieTitle = movieObject.movieTitle;
        self.movieRating = [NSString stringWithFormat:@"%@", movieObject.showAverageRating];
        
    }
    return self;
}

@end
