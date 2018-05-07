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

@property (strong, nonatomic) NSString *youtubeVideoKey;

@end

@implementation AFSEWebContentHandlerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showID = [[NSNumber alloc] init];
    self.showID = self.showIdentifier;

    //NSLog(@"show item media type = %@", self.show.mediaType);
    //NSLog(@"SHOWID = %@", self.showID);
    
    [self getYoutubeVideoKeyWithShowID:self.showID andMediaType:self.show.mediaType];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Fetching
-(void)getYoutubeVideoKeyWithShowID:(NSNumber *)showId andMediaType:(NSString *)mediaType
{
    NSString *query = [NSString stringWithFormat:@"http://api.themoviedb.org/3/%@/%@/videos?api_key=6b2e856adafcc7be98bdf0d8b076851c",mediaType, showId];
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
                        self.youtubeVideoKey = result[@"key"];
                    }
                }
            }
            
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideoOnYoutubeWithKey:self.youtubeVideoKey];
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
