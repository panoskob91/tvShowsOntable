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
        self.movie = movieName;
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
        self.movie = movieName;
        self.summary = movieSummary;
    }
    return self;
    
}

- (instancetype) initWithDictionary: (NSDictionary *)dict andShowObject: (Show *)showObject
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
        
        }else if (![showSummary isEqualToString:@""] ||
                  ![showSummary isEqual:[NSNull null]])
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

- (NSString *)getSummary
{
    return self.summary;
}

- (NSMutableArray<Movie *> *)parseRemoteJSONWithSearchText:(NSString *)userSearchText
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchVC *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    
    //[showsArray removeAllObjects];
    NSMutableArray<Movie *> *showsArray = [[NSMutableArray alloc] init];
    searchVC.tableViewActivityindicator.hidden = NO;
    [searchVC.tableViewActivityindicator startAnimating];
    
    userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *userSearchQuery = [NSString stringWithFormat:@"http://api.tvmaze.com/search/shows?q=%@", userSearchText];
    
    NSURL *searchURL = [NSURL URLWithString:userSearchQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            for (NSDictionary *dict in responseDictionary)
            {
                
                Show *showInfo;
                NSDictionary *showsReturned = dict[@"show"];
                NSString *title = showsReturned[@"name"];
                NSDictionary *image = showsReturned[@"image"];
                NSDictionary *averageRatingDictionary = showsReturned[@"rating"];
                
                NSString *showTitle = [[NSString alloc] init];
                NSString *showImage = [[NSString alloc] init];
                NSNumber *showAverageRating = [[NSNumber alloc] init];
                NSString *showDescription = [[NSString alloc] init];
                
                if (title)
                {
                    
                    showTitle = title;
                    
                }else if (!title){
                    
                    showTitle = @"";
                    
                }
                if (averageRatingDictionary[@"average"] == [NSNull null])
                {
                    
                    showAverageRating = (NSNumber *)@"";
                    
                    
                }else if (averageRatingDictionary[@"average"] != [NSNull null]){
                    
                    showAverageRating = averageRatingDictionary[@"average"];
                    showAverageRating = @(showAverageRating.floatValue);
                    
                    
                }
                
                if ([showsReturned[@"summary"] isEqual:[NSNull null]] ||
                    [showsReturned[@"summary"] isEqualToString:@""])
                {
                    
                    showDescription = @"No summary available";
                    
                }else if (![showsReturned[@"summary"] isEqualToString:@""] ||
                          ![showsReturned[@"summary"] isEqual:[NSNull null]]){
                    
                    showDescription = showsReturned[@"summary"];
                    
                }
                
                if ([image isEqual:[NSNull null]])
                {
                    
                    showImage = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
                    
                }else{
                    
                    NSString *originalImage = image[@"original"];
                    NSString *mediumImage = image[@"medium"];
                    
                    
                    if ((![originalImage isEqual:[NSNull null]]) && (![mediumImage isEqual:[NSNull null]]))
                    {
                        
                        showImage = originalImage;
                        
                    }else if ((![originalImage isEqual:[NSNull null]]) && ([mediumImage isEqual:[NSNull null]]))
                    {
                        
                        showImage = originalImage;
                        
                    }else if ([originalImage isEqual:[NSNull null]] && (![mediumImage isEqual:[NSNull null]]))
                    {
                        
                        showImage = mediumImage;
                        
                    }else if ([originalImage isEqual:[NSNull null]] && [mediumImage isEqual:[NSNull null]])
                    {
                        
                        showImage = @"http://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
                        
                    }
                }
                
                showDescription = [showDescription stripHtml];
                
                showInfo = [[Show alloc] initWithTitle:showTitle
                                              andImage:showImage
                                      andAverageRating:showAverageRating];
                
                Movie *movie = [[Movie alloc] initWithMovie:showTitle andSummary:showDescription andShowObject:showInfo];
                [showsArray addObject:movie];
            }
            
        }
        else{
            NSLog(@"ERROR %@", error);
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [searchVC.tableView reloadData];
//            searchVC.tableViewActivityindicator.hidden = YES;
//            [searchVC.tableViewActivityindicator stopAnimating];
//            [self updateUIElements];
//
//        });
       
      
    }];
    [dataTask resume];
    
    return showsArray;
}

- (void) updateUIElements
{
    
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SearchVC *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
                [searchVC.tableView reloadData];
                searchVC.tableViewActivityindicator.hidden = YES;
                [searchVC.tableViewActivityindicator stopAnimating];
}


@end
