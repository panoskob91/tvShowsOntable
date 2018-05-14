//
//  Show.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"
#import "SearchVC.h"

@interface Show ()

@property (strong, nonatomic) NSNumber *showId;

@end

@implementation Show

#pragma mark -Class initialisers
- (instancetype)initWithTitle:(NSString *)ST
                     andImage:(NSString *)SI
             andAverageRating:(NSNumber *)SAR
{
    self = [super init];
    
    if (self)
    {
        self.showTitle = ST;
        self.showImageUrlPath = SI;
        self.showAverageRating = SAR;
    }
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *showsDict = dict[@"show"];
        NSDictionary *showImage = showsDict[@"image"];
        NSDictionary *showAverageRatingDictionary = showsDict[@"rating"];
        NSNumber *showAverageRating = showAverageRatingDictionary[@"average"];
        NSNumber *showID = showsDict[@"id"];
        
        if ([showAverageRating isEqual:[NSNull null]])
        {
            self.showAverageRating = (NSNumber *)@"";
        }else if (![showAverageRating isEqual:[NSNull null]]){
            self.showAverageRating = @(showAverageRating.floatValue);
        }
        
        NSString *showTitle = showsDict[@"name"];
        //Handle Title
        if (showTitle)
        {
            self.showTitle = showTitle;
        }else if (!showTitle){
            self.showTitle = @"";
        }
        //Handle id
        if (showID)
        {
            self.showId = showID;
        }
        
        //Handle images
        if ([showImage isEqual: [NSNull null]])
        {
            self.showImageUrlPath = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
        }else{
            NSString *originalImage = showImage[@"original"];
            NSString *mediumImage = showImage[@"medium"];
            
            if ((![originalImage isEqual:[NSNull null]]) && (![mediumImage isEqual:[NSNull null]]))
            {
                self.showImageUrlPath = originalImage;
            }else if ((![originalImage isEqual:[NSNull null]]) && ([mediumImage isEqual:[NSNull null]]))
            {
                self.showImageUrlPath = originalImage;
            }else if ([originalImage isEqual:[NSNull null]] && (![mediumImage isEqual:[NSNull null]]))
            {
                self.showImageUrlPath = mediumImage;
            }else if ([originalImage isEqual:[NSNull null]] && [mediumImage isEqual:[NSNull null]])
            {
                self.showImageUrlPath = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
            }
        }
    }
    return self;
}

//Show initialiser. The dictionary passed as argument must be inside results child of the API response.
- (instancetype)initWithDictionaryForTvDb:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        //Show Id
        if (![dict[@"id"] isEqual:[NSNull null]])
        {
            self.showId = dict[@"id"];
        }
        
        //Show title
        if ([dict[@"media_type"] isEqualToString:@"tv"])
        {
            self.showTitle = dict[@"name"];
        }
        else if ([dict[@"media_type"] isEqualToString:@"movie"])
        {
            self.showTitle = dict[@"title"];
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
        //Handle media type
        if (![dict[@"media_type"] isEqual:[NSNull null]])
        {
            if ([dict[@"media_type"] isEqualToString:@"tv"])
            {
                self.mediaType = dict[@"media_type"];
            }
            else if ([dict[@"media_type"] isEqualToString:@"movie"])
            {
                self.mediaType = dict[@"media_type"];
            }
        }
        
        //Show image
        if (![dict[@"poster_path"] isEqual:[NSNull null]])
        {
            self.showImageUrlPath = [NSString stringWithFormat:
                              @"http://image.tmdb.org/t/p/w185/%@", dict[@"poster_path"]];
        }
        else if ([dict[@"poster_path"] isEqual:[NSNull null]])
        {
            //If there is no poser image fall back to default tvmaze image url
            self.showImageUrlPath = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
        }
        //Genre ID
        NSArray *genre_ids = dict[@"genre_ids"];
        if (genre_ids.count != 0)
        {
            self.showGenreID = genre_ids.firstObject;
        }
        
    }
    return self;
}

#pragma mark -Private properties getters
- (NSNumber *)getShowId
{
    return self.showId;
}

@end
