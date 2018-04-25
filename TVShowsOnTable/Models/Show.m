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
        self.showImage = SI;
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
        
        
        
        //Handle images
        if ([showImage isEqual: [NSNull null]])
        {
            
            self.showImage = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
            
        }else{
            
            NSString *originalImage = showImage[@"original"];
            NSString *mediumImage = showImage[@"medium"];
            
            
            if ((![originalImage isEqual:[NSNull null]]) && (![mediumImage isEqual:[NSNull null]]))
            {
                
                self.showImage = originalImage;
                
            }else if ((![originalImage isEqual:[NSNull null]]) && ([mediumImage isEqual:[NSNull null]]))
            {
                
                self.showImage = originalImage;
                
            }else if ([originalImage isEqual:[NSNull null]] && (![mediumImage isEqual:[NSNull null]]))
            {
                
                self.showImage = mediumImage;
                
            }else if ([originalImage isEqual:[NSNull null]] && [mediumImage isEqual:[NSNull null]])
            {
                
                self.showImage = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
                
            }
        }
    }
    
    return self;
}

//Must be inside results
- (instancetype) initWithDictionaryForTvDb:(NSDictionary *)dict
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
        
        //Show image
        if (![dict[@"poster_path"] isEqual:[NSNull null]])
        {
            self.showImage = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w185/%@", dict[@"poster_path"]];
        }
    }
    return self;
}

#pragma mark -Private properties getters
- (NSNumber *) getShowId
{
    return self.showId;
}

@end
