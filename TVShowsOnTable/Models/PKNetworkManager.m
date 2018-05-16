//
//  AFSENetworking.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 07/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKNetworkManager.h"
#import "Movie.h"
#import "TVSeries.h"


@implementation PKNetworkManager

- (void)fetchAPICallWithSearchText:(NSString *)userSearchText
{
    self.shows = [[NSMutableArray alloc] init];
    
    userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/multi?api_key=%@&query=%@", THE_MOVIE_DB_API_KEY, userSearchText];
    
    NSURL *searchURL = [NSURL URLWithString:userSearchQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            Show *showInfo;
            TVSeries *tvSerie;
            Movie *showMovie;
            NSDictionary *resultsArray = responseDictionary[@"results"];
            for (NSDictionary *dict in resultsArray)
            {
                showInfo = [[Show alloc] initWithDictionaryForTvDb:dict];
                if ([dict[@"media_type"] isEqualToString:@"tv"])
                {
                    
                    tvSerie = [[TVSeries alloc] initWithDictionaryForTvDbAPI:dict];
                    [self.shows addObject:tvSerie];
                }
                else if ([dict[@"media_type"] isEqualToString:@"movie"])
                {
                    showMovie = [[Movie alloc] initWithResponseDictionaryFromTvDb:dict];
                    [self.shows addObject:showMovie];
                }
            }
            
            if ([self.networkingDelegate respondsToSelector:@selector(networkAPICallDidCompleteWithResponse:)])
            {
                [self.networkingDelegate networkAPICallDidCompleteWithResponse:self.shows];
            }
        }
        else{
            NSLog(@"ERROR %@", error);
            if ([self.networkingDelegate respondsToSelector:@selector(networkAPICallDidCompleteWithResponse:)])
            {
                [self.networkingDelegate networkAPICallDidCompleteWithResponse:self.shows];
            }
        }
    }];
    [dataTask resume];
    
}

- (void)fetchDescriptionFromId:(NSNumber *)showId
                  andMediaType:(ShowType)mediaType
{
    NSString *userSearchQuery = [[NSString alloc] init];
    if (mediaType == ShowTypeMovie)
    {
        userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/%@/%@?api_key=%@",@"movie", showId, THE_MOVIE_DB_API_KEY];
    }
    else if (mediaType == ShowTypeTVSeries)
    {
        userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/%@/%@?api_key=%@",@"tv", showId, THE_MOVIE_DB_API_KEY];
    }
    NSURL *searchURL = [NSURL URLWithString:userSearchQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
           
            NSString *summary = [[NSString alloc] init];
            
            NSString *responseSummary = responseDictionary[@"overview"];
            if ([responseSummary isEqual:[NSNull null]]
                || [responseSummary isEqualToString:@""])
            {
                summary = @"No summary available";
            }
            else
            {
                summary = responseSummary;
            }
            if ([self.networkingDelegate respondsToSelector:@selector(APIFetchedWithResponseDescriptionProperty:)])
            {
                [self.networkingDelegate APIFetchedWithResponseDescriptionProperty:summary];
            }
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        
    }];
    [dataTask resume];
}

- (void)getYoutubeVideoKeyWithShowID:(NSNumber *)showId
                        andMediaType:(ShowType)mediaType
{
    self.youtubeKey = [[NSString alloc] init];
    NSString *query = [[NSString alloc] init];
    if (mediaType == ShowTypeMovie) {
        query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/%@/%@/videos?api_key=6b2e856adafcc7be98bdf0d8b076851c",@"movie", showId];
    }
    else if (mediaType == ShowTypeTVSeries)
    {
        query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/%@/%@/videos?api_key=6b2e856adafcc7be98bdf0d8b076851c",@"tv", showId];
    }
    
    NSURL *searchURL = [NSURL URLWithString:query];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (![responseDictionary[@"results"] isEqual:[NSNull null]])
            {
                
                NSDictionary *resultsDictionary = responseDictionary[@"results"];
                for (NSDictionary* result in resultsDictionary)
                {
                    if ([result[@"type"] isEqualToString:@"Trailer"])
                    {
                        //youtubeVideoKey = result[@"key"];
                        self.youtubeKey = result[@"key"];
                    }
                }
                
            }
            if ([self.networkingDelegate respondsToSelector:@selector(networkCallDidCompleteAndYoutubeKeyGenerated:)])
            {
                [self.networkingDelegate networkCallDidCompleteAndYoutubeKeyGenerated:self.youtubeKey];
            }
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        
    }];
    [dataTask resume];
}

@end
