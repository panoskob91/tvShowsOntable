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
#import "AFSEGenreModel.h"

@interface PKNetworkManager ()

@property (strong, nonatomic) NSDictionary *tvGenresDictionary;
@property (strong, nonatomic) NSDictionary *movieGenresDictionary;

@property (strong, nonatomic) NSMutableDictionary *totalGenresDictionary;

@end

@implementation PKNetworkManager

#pragma mark - Initialisers

- (instancetype)initWithFavoritesObject:(List *)favorite
{
    self = [super init];
    if (self)
    {
        self.favorite = favorite;
    }
    return self;
}


#pragma mark - Fetch API and initialise Show objects

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
#pragma mark - Fetch show description

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

#pragma mark - Fetch youtube key

- (void)getYoutubeVideoKeyWithShowID:(NSNumber *)showId
                        andMediaType:(ShowType)mediaType
{
    self.youtubeKey = [[NSString alloc] init];
    NSString *query = [[NSString alloc] init];
    if (mediaType == ShowTypeMovie) {
        query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/%@/%@/videos?api_key=%@",@"movie", showId, THE_MOVIE_DB_API_KEY];
    }
    else if (mediaType == ShowTypeTVSeries)
    {
        query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/%@/%@/videos?api_key=%@",@"tv", showId, THE_MOVIE_DB_API_KEY];
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
#pragma mark - Fetch genres

-(void)getTVGenreNameAndGenreIdWithSuccessBlock:(void (^)(NSDictionary *tvDictionary))sBlock
{
    NSMutableDictionary *tvGenresDictionary = [[NSMutableDictionary alloc] init];

    NSString *moviesGenreQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/genre/tv/list?api_key=%@&language=en-US", THE_MOVIE_DB_API_KEY];
    
    NSURL *searchURL = [NSURL URLWithString:moviesGenreQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            AFSEGenreModel *genreModel;
            for (NSDictionary *dict in responseDictionary[@"genres"])
            {
                if (dict[@"id"] &&
                    dict[@"name"])
                {
                    genreModel = [[AFSEGenreModel alloc] initWithGenreID:dict[@"id"]
                                                            andGenreName:dict[@"name"]];
                    
                }
                NSString *genreKey = [NSString stringWithFormat:@"%@", genreModel.genreID];
                [tvGenresDictionary setValue:genreModel.genreName forKey:genreKey];
            }
            //sBlock(tvGenresDictionary);
        }
        
        else
        {
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tvGenresDictionary = [[NSDictionary alloc] init];
        });
    }];
    [dataTask resume];
    
}

#pragma mark - Fetch genre names and ids

- (void)getGenreNameAndIdsWithMediaType:(ShowType)mediaType
                              andWithSucessBlock:(void(^)(NSDictionary *dictionary))sBlock
{
    NSMutableDictionary *genresDictionary = [[NSMutableDictionary alloc] init];
    NSString *moviesGenreQuery = [[NSString alloc] init];
    if (mediaType == ShowTypeMovie)
    {
        moviesGenreQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/genre/%@/list?api_key=%@&language=en-US", @"movie",THE_MOVIE_DB_API_KEY];
    }
    else if (mediaType == ShowTypeTVSeries)
    {
        moviesGenreQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/genre/%@/list?api_key=%@&language=en-US", @"tv", THE_MOVIE_DB_API_KEY];
    }
    NSURL *searchURL = [NSURL URLWithString:moviesGenreQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            //AFSEGenreModel *genreModel;
            for (NSDictionary *dict in responseDictionary[@"genres"])
            {
                if (dict[@"id"] &&
                    dict[@"name"])
                {
                    [genresDictionary setObject:dict[@"name"] forKey:dict[@"id"]];
                }
                //NSString *genreKey = [NSString stringWithFormat:@"%@", genreModel.genreID];
                //[genresDictionary setValue:genreModel.genreName forKey:genreKey];
            }
            sBlock(genresDictionary);
        }
        
        else
        {
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.tvGenresDictionary = [[NSDictionary alloc] initWithDictionary:movieGenresDictionary];
        });
    }];
    [dataTask resume];
}
#pragma mark - Get genre info (name and ID)

- (void)getGenreNameAndIDSWithCompletionBlock:(void(^)(NSDictionary *dictionary))cBlock
{
    self.totalGenresDictionary = [[NSMutableDictionary alloc] init];
    
    [self getGenreNameAndIdsWithMediaType:ShowTypeTVSeries
                       andWithSucessBlock:^(NSDictionary *dictionary) {
                           for (NSString *key in dictionary)
                           {
                               [self.totalGenresDictionary setObject:dictionary[key] forKey:key];
                           }
                           
                           [self getGenreNameAndIdsWithMediaType:ShowTypeMovie andWithSucessBlock:^(NSDictionary *dictionary)
                           {
                               self.movieGenresDictionary = dictionary;
                               for (NSString *key in dictionary)
                               {
                                   if(![self.totalGenresDictionary objectForKey:@"id"])
                                   {
                                       [self.totalGenresDictionary setObject:dictionary[key] forKey:key];
                                   }
                               }
                                cBlock(self.totalGenresDictionary);
                           }];
    }];
    
}

@end
