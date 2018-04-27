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
@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;
@property (strong, nonatomic) NSMutableArray<TVSeries *> *series;
@property (nonatomic, assign) BOOL contentIsEditable;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableViewActivityindicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *enableEditBTN;

- (IBAction)pickShowVCButtonPSD:(id)sender;
- (IBAction)enableEditButtonPressed:(UIBarButtonItem *)sender;

/**
 TV maze API parsing function. GET Request type used. Data is stored in a Show Class array object
  @param userSearchText Takes user input as a parameters
 */
- (void) fetchRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

@implementation SearchVC

NSMutableDictionary *showsData;
NSArray *selectedCells;

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupSearchBar];
    [self initialiseTheNeededArrays];
    self.title = @"Shows";
    self.contentIsEditable = true;
    self.tableViewActivityindicator.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -View setup functions
- (void) initialiseTheNeededArrays
{
    //Initialise shows array
    self.shows = [[NSMutableArray alloc] init];
    //Initialise series array
    self.series = [[NSMutableArray alloc] init];
    //Initialise searched text
    self.searchedText = [[NSString alloc] init];
    //Initialise movies array
    self.movies = [[NSMutableArray alloc] init];
    showsData = [[NSMutableDictionary alloc] init];
}

- (void) setupTableView
{
    //Set the delegate and dataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelection = YES;
    
    //TableView visuals
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 100;
    self.tableView.estimatedRowHeight = 140;
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

- (IBAction)enableEditButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.contentIsEditable == YES)
    {
        self.tableView.editing = YES;
        self.contentIsEditable = NO;
    }
    else
    {
        self.tableView.editing = NO;
        self.contentIsEditable = YES;
    }
    
}

#pragma mark -UITableView Data source functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[showsData allKeys] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *showTitles = [showsData allKeys];
    return showTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == 0)
    {
        return self.series.count;
    }
    else if (section == 1)
    {
        return self.movies.count;
    }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    selectedCells = [self.tableView indexPathsForSelectedRows];
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    NSNumber *showID = [[NSNumber alloc] init];
    if (indexPath.section == 0)
    {
        detailsVC.navigationItemTitle = self.series[indexPath.row].showTitle;
        detailsVC.imageURL = self.series[indexPath.row].showImage;
        showID = [self.series[indexPath.row] getShowId];
        
    }
    else if (indexPath.section == 1)
    {
        detailsVC.navigationItemTitle = self.movies[indexPath.row].movie;
        detailsVC.imageURL = self.movies[indexPath.row].showImage;
        showID = [self.movies[indexPath.row] getShowId];
        
    }
    [detailsVC setTheShowID:showID];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete){
    
        if (indexPath.section == 0)
        {
            [self.series removeObjectAtIndex: indexPath.row];
        }
        else if (indexPath.section == 1)
        {
            [self.movies removeObjectAtIndex: indexPath.row];
        }
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    if ((sourceIndexPath.section == 0) && (destinationIndexPath.section == 0))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TVSeries *objectToBeMoved = self.series[sourceIndexPath.row];
            //[self.tableView beginUpdates];
            [self.series removeObjectAtIndex:sourceIndexPath.row];
            [self.series insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.tableView endUpdates];
                [self.tableView reloadData];
            });
        });
    }
    else if ((sourceIndexPath.section == 1) && (destinationIndexPath.section == 1))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Movie *objectToBeMoved = self.movies[sourceIndexPath.row];
            //[self.tableView beginUpdates];
            [self.movies removeObjectAtIndex:sourceIndexPath.row];
            [self.movies insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.tableView endUpdates];
                [self.tableView reloadData];
            });
        });
    }
    
    else
    {
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //if ([self.shows[sourceIndexPath.row] isKindOfClass:[TVSeries class]])
            if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    Show *removedElement = (Show *)self.series[sourceIndexPath.row];
                    //[self.tableView beginUpdates];
                    [self.series removeObjectAtIndex:sourceIndexPath.row];
                    [self.movies insertObject:(Movie *)removedElement atIndex:destinationIndexPath.row];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[self.tableView endUpdates];
                        [self.tableView reloadData];
                    });
                //[self rearangeTableCellsOnTwoDifferentSectionsWhenFirstSectionIsSeries:YES
                //                                                             fromIndex:sourceIndexPath toIndex:destinationIndexPath];
                });
            }
            //else if ([self.shows[sourceIndexPath.row] isKindOfClass:[Movie class]])
            else if (sourceIndexPath.section == 1 && destinationIndexPath.section == 0)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    Show *removedElement = (Movie *)self.movies[sourceIndexPath.row];
                    //[self.tableView beginUpdates];
                    [self.movies removeObjectAtIndex:sourceIndexPath.row];
                    [self.series insertObject:(TVSeries *)removedElement atIndex:destinationIndexPath.row];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[self.tableView endUpdates];
                        [self.tableView reloadData];
                        //[self rearangeTableCellsOnTwoDifferentSectionsWhenFirstSectionIsSeries:NO
                        //                                                             fromIndex:sourceIndexPath toIndex:destinationIndexPath];
                    });
                });
            }
            
        }];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.tableView reloadData];
            
        }];
        NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
        [alertActions addObject:actionYES];
        [alertActions addObject:actionNO];
        
        UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Attention!" andMessage:@"Are you sure you want to change rows between different sections" andActions:alertActions];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}

#pragma mark -Delegate move cells helper functions
- (void) rearangeTableCellsOnTwoDifferentSectionsWhenFirstSectionIsSeries: (BOOL)check
                                                                fromIndex: (NSIndexPath *)sourceIndexPath
                                                                  toIndex: (NSIndexPath *)destinationIndexPath
{
    if (check)
    {
        Show *removedElement = (Show *)self.series[sourceIndexPath.row];
        [self.series removeObjectAtIndex:sourceIndexPath.row];
        [self.movies insertObject:(Movie *)removedElement atIndex:destinationIndexPath.row];
        [self.tableView reloadData];
    }
    else
    {
        Show *removedElement = (Movie *)self.movies[sourceIndexPath.row];
        [self.movies removeObjectAtIndex:sourceIndexPath.row];
        [self.series insertObject:(TVSeries *)removedElement atIndex:destinationIndexPath.row];
        [self.tableView reloadData];
    }
}


#pragma mark -UITTableView delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
     TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tVShowsCell"];
    
    if (indexPath.row <= self.shows.count && self.shows.count != 0){
        if (indexPath.section == 0) {
        
            cell.showTitleLabel.text = self.series[indexPath.row].showTitle;
            NSURL *imageURL = [NSURL URLWithString:self.series[indexPath.row].showImage];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        
            cell.TVShowsImage.image = [UIImage imageWithData:imageData];
            cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
        
            //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
            cell.averageRating.text = [NSString stringWithFormat:@"%@", self.series[indexPath.row].showAverageRating];
            
            cell.layer.cornerRadius = 10;
                //return cell;
        }
        else if (indexPath.section == 1)
        {
            cell.showTitleLabel.text = self.movies[indexPath.row].showTitle;
            NSURL *imageURL = [NSURL URLWithString:self.movies[indexPath.row].showImage];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
            
            cell.TVShowsImage.image = [UIImage imageWithData:imageData];
            cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
            
            //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
            cell.averageRating.text = [NSString stringWithFormat:@"%@", self.movies[indexPath.row].showAverageRating];
            
            cell.layer.cornerRadius = 10;
            //return cell;
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
    [self.series removeAllObjects];
    [showsData removeAllObjects];
    
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
            TVSeries *tvSerie;
            
            for (NSDictionary *dict in responseDictionary[@"results"])
            {
                
                if ([dict[@"media_type"] isEqualToString:@"tv"])
                {
                    showInfo = [[Show alloc] initWithDictionaryForTvDb:dict];
                    tvSerie = [[TVSeries alloc] initWithDictionaryForTvDbAPI:dict];
                    [self.series addObject:tvSerie];
                    //[self.shows addObject: showInfo];
                    [self.shows addObject:tvSerie];
                }
                else if ([dict[@"media_type"] isEqualToString:@"movie"])
                {
                    showMovie = [[Movie alloc] initWithResponseDictionaryFromTvDb:dict];
                    [self.movies addObject: showMovie];
                    [self.shows addObject:showMovie];
                }
            }
            
            [showsData setValue:self.series forKey:@"Series"];
            [showsData setValue:self.movies forKey:@"Movies"];
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


