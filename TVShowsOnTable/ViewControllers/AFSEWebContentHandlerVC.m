//
//  AFSEWebContentHandlerVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSEWebContentHandlerVC.h"
#import <WebKit/WebKit.h>

@interface AFSEWebContentHandlerVC ()

@property (strong, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation AFSEWebContentHandlerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://www.youtube.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
