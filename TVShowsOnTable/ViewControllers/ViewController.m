//
//  ViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//
#import "ViewController.h"
#import "TVSeries.h"
#import "Movie.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;

@end

@implementation ViewController

    //NSMutableArray<Show *> *shows;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Shows";
    
    //Initialise shows array
    self.shows = [[NSMutableArray alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.placeholder = @"Search";
    
    self.searchBar.delegate = self;
    
//    self.searchedText = self.searchBar.text;
    
    //[self parseLocalJSONFileWithName:@"showData"];
    [self parseRemoteJSONWithSearchText:_searchedText];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchedText = self.searchBar.text;
    [self parseRemoteJSONWithSearchText:_searchedText];
    [self.searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVShowsCell"];
    
    cell.showTitleLabel.text = self.shows[indexPath.row].showTitle;
    
    NSURL *imageURL = [NSURL URLWithString:self.shows[indexPath.row].showImage];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    cell.TVShowsImage.image = [UIImage imageWithData:imageData];
    //cell.showsTitleDescription.text = self.shows[indexPath.row].showDescription;
    cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
    cell.averageRating.text = [NSString stringWithFormat:@"%@", self.shows[indexPath.row].showAverageRating];
    
    cell.layer.cornerRadius = 10;
    
        return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    //detailsViewController.detailsViewInfoLabel.text = self.showDescription[indexPath.row];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *detailsVC = segue.destinationViewController;
        //detailsVC.labelValue = self.shows[indexPath.row].showDescription;
        detailsVC.labelValue = [self.shows[indexPath.row] getSummary];//Read summary from a private property
        detailsVC.navigationItemTitle = self.shows[indexPath.row].showTitle;
    }
    
}


//remove bottom lines
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [UIView new];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

//custom cell height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

//- (void)parseLocalJSONFileWithName:(NSString *)fileName
//{
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
//        NSError *error;
//        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
//        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//        NSArray *items = [jsonDictionary valueForKey:@"Shows"];
//        
//        for (NSDictionary *item in items)
//        {
//            Show *showInfo = [[Show alloc] init];
//            [showInfo setShowTitle:item[@"name"]];
//            [showInfo setShowImage:item[@"image"]];
//            [showInfo setShowDescription:item[@"description"]];
//            NSDictionary *rating = item[@"rating"];
//            NSNumber *average = rating[@"average"];
//            if (![average isEqual:[NSNull null]])
//            {
//                [showInfo setAverageRating:average];
//            }else{
//                [showInfo setAverageRating:(NSNumber *)@""];
//            }
//            [shows addObject:showInfo];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//        
//    });
//    
//}
- (void)parseRemoteJSONWithSearchText: (NSString *)userSearchText
{
    [self.shows removeAllObjects];
    
    userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                    
                    [self.shows addObject:movie];
                }
            }
            else{
                NSLog(@"ERROR %@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                

                [self.tableView reloadData];

            });
        }];
        [dataTask resume];
    
    //});
    
}


@end
