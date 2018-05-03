//
//  Movie.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Movie.h"
#import "SearchVC.h"
#import "NSString_stripHtml.h"

@interface Movie ()

@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSNumber *showId;

@end

@implementation Movie


#pragma mark -Initialisers
- (instancetype)initWithMovie: (NSString *)movieName
                   andSummary:(NSString *)movieSummary
                andShowObject:(Show *)showObject
{
    
    self = [super init];
    
    if (self)
    {
        self.movieTitle = movieName;
        self.summary = movieSummary;
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        self.showAverageRating = showObject.showAverageRating;
        
    }
    
    return self;
    
}

- (instancetype)initWithMovieName: (NSString *)movieName
                  andMovieSummary: (NSString *)movieSummary
{
    self = [super init];
    
    if (self)
    {
        self.movieTitle = movieName;
        self.summary = movieSummary;
    }
    return self;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dict andShowObject:(Show *)showObject
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *showDictionary = dict[@"show"];
        NSString *showSummary = showDictionary[@"summary"];
        
        if ([showSummary isEqual:[NSNull null]] ||
            [showSummary isEqualToString:@""])
        {
            self.summary = @"No summary available";
        }else if (![showSummary isEqualToString:@""]
                  || ![showSummary isEqual:[NSNull null]])
        {
            showSummary = [showSummary stripHtml];
            self.summary = showSummary;
        }
        
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        self.showAverageRating = showObject.showAverageRating;
        
    }
    return self;
}

- (instancetype)initWithDictionaryFromTvDb:(NSDictionary *)dict
                             andShowObject:(Show *)showObject
{
    self = [super init];
    
    if (self)
    {
        
        //Title
        if ([dict[@"media_type"] isEqualToString:@"tv"])
        {
            self.movieTitle = dict[@"name"];
        }
        else if ([dict[@"media_type"] isEqualToString:@"movie"])
        {
            self.movieTitle = dict[@"title"];
        }
        //Summary
        if ([dict[@"overview"] isEqual:[NSNull null]])
        {
            self.summary = @"No summary available";
        }else
        {
            self.summary = dict[@"overview"];
        }
        self.showTitle = showObject.showTitle;
        self.showImage = showObject.showImage;
        self.showAverageRating = showObject.showAverageRating;
        self.showId = [showObject getShowId];
    }
    return self;
}

- (instancetype)initWithResponseDictionaryFromTvDb:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        //Title
        if ([dict[@"media_type"] isEqualToString:@"tv"])
        {
            self.movieTitle = dict[@"name"];
        }
        else if ([dict[@"media_type"] isEqualToString:@"movie"])
        {
            self.movieTitle = dict[@"title"];
        }
        //Summary
        if ([dict[@"overview"] isEqual:[NSNull null]])
        {
            self.summary = @"No summary available";
        }
        else
        {
            self.summary = dict[@"overview"];
        }
        //Image
        if (![dict[@"poster_path"] isEqual:[NSNull null]])
        {
            self.showImage = [NSString stringWithFormat:
                              @"http://image.tmdb.org/t/p/w185/%@", dict[@"poster_path"]];
        }
        //Average rating
        if (![dict[@"vote_average"] isEqual:[NSNull null]])
        {
            self.showAverageRating = dict[@"vote_average"];
            self.showAverageRating = @(self.showAverageRating.floatValue);
        }
        else
        {
            self.showAverageRating = (NSNumber *)@"";
            self.showAverageRating = @(self.showAverageRating.floatValue);
        }
        //Show Id
        if (![dict[@"id"] isEqual:[NSNull null]])
        {
            self.showId = dict[@"id"];
        }
        self = [super initWithDictionaryForTvDb:dict];
    }
    return self;
}

#pragma mark -Getters
- (NSString *)getSummary
{
    return self.summary;
}
- (NSNumber *)getShowId
{
    return self.showId;
}


@end
