//
//  AFSEWebContentHandlerVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSEWebContentHandlerVC.h"
#import <WebKit/WebKit.h>
#import "UIAlertController+AFSEAlertGenerator.h"

@interface AFSEWebContentHandlerVC ()

@property (strong, nonatomic) IBOutlet WKWebView *webView;

@property (strong, nonatomic) NSNumber *showID;
@property (strong, nonatomic) NSString *youtubeMovieVideoKey;
@property (strong, nonatomic) NSString *youtubeTVVideoKey;

@end

@implementation AFSEWebContentHandlerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showID = [[NSNumber alloc] init];
    self.showID = self.showIdentifier;
    self.youtubeMovieVideoKey = [[NSString alloc] init];
    self.youtubeTVVideoKey = [[NSString alloc] init];
    
    NSLog(@"show item media type = %@", self.show.mediaType);
    NSLog(@"SHOWID = %@", self.showID);
    
    [self getYoutubeVieoIdWithShowID:self.showID
                    andMediaTypeName:self.show.mediaType];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
     
- (void)getYoutubeVieoIdWithShowID:(NSNumber *)showId andMediaTypeName:(NSString *)mediatype
{
    if ([mediatype isEqualToString:@"movie"])
    {
        [self getYoutubeMovieIdFromAPIWithShowID:showId];
    }
    else if ([mediatype isEqualToString:@"tv"])
    {
        [self getYoutubeTVVideoKeyWithShowID:showId];
    }
}
#pragma mark -Parsing methods
-(void)getYoutubeTVVideoKeyWithShowID:(NSNumber *)showId
{
    NSString *query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%@/videos?api_key=6b2e856adafcc7be98bdf0d8b076851c", showId];
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
                        self.youtubeTVVideoKey = result[@"key"];
                    }
                }
            }
            
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideoOnYoutubeWithKey:self.youtubeTVVideoKey];
        });
    }];
    [dataTask resume];
}


- (void)getYoutubeMovieIdFromAPIWithShowID:(NSNumber *)showID
{
    NSString *query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/videos?api_key=6b2e856adafcc7be98bdf0d8b076851c", showID];
    
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
                for (NSDictionary *result in resultsDictionary)
                {
                    if ([result[@"type"] isEqualToString:@"Trailer"])
                    {
                        self.youtubeMovieVideoKey = result[@"key"];
                    }
                }
            }
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideoOnYoutubeWithKey:self.youtubeMovieVideoKey];
        });
    }];
    [dataTask resume];
    
}

- (void)playVideoOnYoutubeWithKey:(NSString *)youtubeVideoKey
{
    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.youtube.com/watch?v=%@", youtubeVideoKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
