//
//  PKMovieCellViewModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface PKMovieCellViewModel : NSObject

@property (strong, nonatomic) Movie *bindModel;

- (instancetype)initWithMovieModel:(Movie *)movieObject;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *movieRating;

@end
