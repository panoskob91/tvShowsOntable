//
//  AFSENetworking.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 07/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSENetworkManager.h"
#import "Movie.h"
#import "TVSeries.h"


@implementation AFSENetworkManager

- (void)fetchAPICallWithSearchText:(NSString *)userSearchText
{

    self.shows = [[NSMutableArray alloc] init];
    
    userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/multi?api_key=6b2e856adafcc7be98bdf0d8b076851c&query=%@", userSearchText];
    
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
            
            for (NSDictionary *dict in responseDictionary[@"results"])
            {
                if ([dict[@"media_type"] isEqualToString:@"tv"])
                {
                    showInfo = [[Show alloc] initWithDictionaryForTvDb:dict];
                    tvSerie = [[TVSeries alloc] initWithDictionaryForTvDbAPI:dict];
                    [self.shows addObject:tvSerie];
                }
                else if ([dict[@"media_type"] isEqualToString:@"movie"])
                {
                    showMovie = [[Movie alloc] initWithResponseDictionaryFromTvDb:dict];
                    [self.shows addObject:showMovie];
                }
                
            }
            
            [self.networkingDelegate networkAPICallDidCompleteWithResponse:self.shows];
            
        }
        else{
            NSLog(@"ERROR %@", error);
            NSLog(@"status code = %ld", (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

- (void)fetchDescriptionFromId:(NSNumber *)showId
                  andMediaType:(NSString *)mediaType
{
    
    NSString *userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/%@/%@?api_key=6b2e856adafcc7be98bdf0d8b076851c",mediaType, showId];
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
            [self.networkingDelegate APIFetchedWithResponseDescriptionProperty:summary];
            
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        
    }];
    [dataTask resume];
}

@end
