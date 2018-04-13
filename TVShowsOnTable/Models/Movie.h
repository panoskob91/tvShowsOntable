//
//  Movie.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"

@interface Movie : Show

@property (strong, nonatomic) NSString *movie;
@property (strong, nonatomic) NSString *summary;

//- (instancetype)initiWithMovie: (NSString *)movieName Summary:(NSString *)smovieSummary;
- (NSString *)getSummary;
@end