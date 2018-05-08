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
#import "AFSENetworkManager.h"

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
    //[self getYoutubeVideoKeyWithShowID:self.showID andMediaType:self.show.mediaType];
    
    AFSENetworkManager *networkManager = [[AFSENetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager getYoutubeVideoKeyWithShowID:self.showID andMediaType:self.show.mediaType];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    
}
- (void)networkCallDidCompleteAndYoutubeKeyGenerated:(NSString *)youtubeKey
{
//    NSLog(@"youtubeKey is : %@", youtubeKey);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playVideoOnYoutubeWithKey:youtubeKey];
    });
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
