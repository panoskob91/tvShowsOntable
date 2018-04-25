//
//  ViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "SearchVC.h"
#import "TVSeries.h"
#import "Movie.h"
#import "UIAlertController+AFSEAlertGenerator.h"

@interface SearchVC ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;
//@property (strong, nonatomic) NSMutableArray<Movie *> *shows;
@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableViewActivityindicator;
- (IBAction)pickShowVCButtonPSD:(id)sender;

/**
 TV maze API parsing function. GET Request type used. Data is stored in a Show Class array object
  @param userSearchText Takes user input as a parameters
 */
- (void) fetchRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

@implementation SearchVC

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupSearchBar];
    self.title = @"Shows";
    
    //Initialise shows array
    self.shows = [[NSMutableArray alloc] init];
    //Initialise searched text
    self.searchedText = [[NSString alloc] init];
    //Initialise movies array
    self.movies = [[NSMutableArray alloc] init];
    
    self.tableViewActivityindicator.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSearchBar
{
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
}
#pragma mark -SearchBar delegate functions
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    self.searchedText = self.searchBar.text;
//    [self parseRemoteJSONWithSearchText:self.searchedText];
//
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.searchedText = self.searchBar.text;
    [self fetchNewRemoteJSONWithSearchText:self.searchedText];
    [searchBar resignFirstResponder];
}

#pragma mark -IBActions
- (IBAction)pickShowVCButtonPSD:(id)sender {
    
    
    PickShowTypeVC *pickShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pickShowTypeVC"];
    pickShowVC.delegate = self;
    [self.navigationController presentViewController:pickShowVC animated:YES completion:NULL];
    
}

#pragma mark -UITableView Data source functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray <NSString *> *secttionTitles = @[@"Tv series", @"Movies"];
    if (section ==0)
    {
        return secttionTitles[0];
    }
    else
    {
        return secttionTitles[1];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == 0)
    {
        return self.shows.count;
    }
    else if (section == 1)
    {
        return self.shows.count;
    }
    
   return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    detailsVC.imageURL = self.shows[indexPath.row].showImage;
    //detailsVC.labelValue = [self.shows[indexPath.row] getSummary];
    detailsVC.navigationItemTitle = self.shows[indexPath.row].showTitle;
    NSNumber *showID = [self.shows[indexPath.row] getShowId];
    [detailsVC setTheShowID:showID];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
#pragma mark -UITTableView delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVShowsCell"];
    
    if (indexPath.row <= self.shows.count && self.shows.count != 0){
        if (indexPath.section == 0) {
        
            cell.showTitleLabel.text = self.shows[indexPath.row].showTitle;
            NSURL *imageURL = [NSURL URLWithString:self.shows[indexPath.row].showImage];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        
            cell.TVShowsImage.image = [UIImage imageWithData:imageData];
            cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
        
            //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
            cell.averageRating.text = [NSString stringWithFormat:@"%@", self.shows[indexPath.row].showAverageRating];
            
            cell.layer.cornerRadius = 10;
                return cell;
        }
        else if (indexPath.section == 1)
        {
            cell.showTitleLabel.text = self.movies[indexPath.row].movie;
            NSURL *imageURL = [NSURL URLWithString:self.movies[indexPath.row].showImage];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
            
            cell.TVShowsImage.image = [UIImage imageWithData:imageData];
            cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
            
            //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
            cell.averageRating.text = [NSString stringWithFormat:@"%@", self.movies[indexPath.row].showAverageRating];
            
            cell.layer.cornerRadius = 10;
            return cell;
        }
        
    }
        return cell;
}

#pragma mark -UITableView footer
//remove bottom lines
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView* footer = [UIView new];
    UIView* footer = [[UIView alloc] init];
    return footer;
}

#pragma mark -Local JSON parsing
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

#pragma mark -Parsing remote JSON form TVMaze API with user input userSearchText
- (void)fetchRemoteJSONWithSearchText: (NSString *)userSearchText
{
    
    [self.shows removeAllObjects];
    [self activityIndicatorHandlerWhenActivityIndicatorIs:NO];
    
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
                    
                    Show *showInfo = [[Show alloc] initWithDictionary:dict];
                    Movie *movie = [[Movie alloc] initWithDictionary:dict andShowObject:showInfo];
                    
                    [self.shows addObject:movie];
                }
            }
            else{
                NSLog(@"ERROR %@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self activityIndicatorHandlerWhenActivityIndicatorIs:YES];
                
            });
        }];
        [dataTask resume];
    
}

- (void)fetchNewRemoteJSONWithSearchText: (NSString *)userSearchText
{
    
    [self.shows removeAllObjects];
    [self.movies removeAllObjects];
    
    [self activityIndicatorHandlerWhenActivityIndicatorIs:NO];
    
    
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
            Movie *showMovie;
            
            for (NSDictionary *dict in responseDictionary[@"results"])
            {
                
                
                if ([dict[@"media_type"] isEqualToString:@"tv"])
                {
                    showInfo = [[Show alloc] initWithDictionaryForTvDb:dict];
                    [self.shows addObject: showInfo];
                }
                else if ([dict[@"media_type"] isEqualToString:@"movie"])
                {
                    showMovie = [[Movie alloc] initWithResponseDictionaryFromTvDb:dict];
                    [self.movies addObject: showMovie];
                }
                
                //Show *showInfo = [[Show alloc] initWithDictionaryForTvDb:dict];
                //Movie *movie = [[Movie alloc] initWithDictionaryFromTvDb:dict andShowObject:showInfo];
                
                //[self.shows addObject:movie];
              
            }
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self activityIndicatorHandlerWhenActivityIndicatorIs:YES];
            
        });
    }];
    [dataTask resume];
    
}


- (void) activityIndicatorHandlerWhenActivityIndicatorIs: (BOOL)activityIndicatorIsHidden
{
    if (activityIndicatorIsHidden == YES)
    {
        self.tableViewActivityindicator.hidden = YES;
        [self.tableViewActivityindicator stopAnimating];
        
    }else{
        
        self.tableViewActivityindicator.hidden = NO;
        [self.tableViewActivityindicator startAnimating];
        
    }
}

#pragma mark -Custom delegates methods
- (void)pickShowTypeVC:(PickShowTypeVC *)pickShowTypeVC didSelectButton:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *alertMessage = [NSString stringWithFormat:@"Button #%@# was pressed", button.currentTitle];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK button pressed");
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel pressed");
    }];
    [actionCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [actionOK setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
    NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
    [alertActions addObject:actionOK];
    [alertActions addObject:actionCancel];
    
    UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Button pressed info" andMessage:alertMessage andActions:alertActions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

@end


