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
#import "AFSEShowGroup.h"
#import "AFSEGenreModel.h"

@interface SearchVC ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;
@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;
@property (strong, nonatomic) NSMutableArray<TVSeries *> *series;
@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroupsArray;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *movieGenres;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *tvGenres;
@property (strong, nonatomic) NSMutableDictionary *movieGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *tvGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *showGenresDictionary;
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
    [self getMovieGenreNameAndGenreId];
    [self getTVGenreNameAndGenreId];
    
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
    //Initialise groups array
    //self.showGroupsArray = [[NSMutableArray alloc] init];
    showsData = [[NSMutableDictionary alloc] init];
    //Initialise movie genres array
    self.movieGenres = [[NSMutableArray alloc] init];
    //Initialise tv genres array
    self.tvGenres = [[NSMutableArray alloc] init];
    //Initialise movie genres dictionary
    self.movieGenresDictionary = [[NSMutableDictionary alloc] init];
    //Initialise tvSeries genres dictionary
    self.tvGenresDictionary = [[NSMutableDictionary alloc] init];
    //Initialise shows genre dictionary
    self.showGenresDictionary = [[NSMutableDictionary alloc] init];
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
    //return [[showsData allKeys] count];
    //return self.showGroupsArray.count;
    NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary];
    return genreNames.count;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSArray *showTitles = [showsData allKeys];
    //return showTitles[section];
    NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary];
    return genreNames[section];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
//    if (section == 0)
//    {
//        return self.series.count;
//    }
//    else if (section == 1)
//    {
//        return self.movies.count;
//    }
//    return -1;
    return self.showGroupsArray[section].dataInSection.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    selectedCells = [self.tableView indexPathsForSelectedRows];
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    NSNumber *showID = [[NSNumber alloc] init];
//    if (indexPath.section == 0)
//    {
        //detailsVC.navigationItemTitle = self.series[indexPath.row].showTitle;
        NSString *showTitleFromGroups = self.showGroupsArray[indexPath.section].dataInSection[indexPath.row].showTitle;
        
        detailsVC.navigationItemTitle = showTitleFromGroups;
    
    NSString *imageURLFromGroups = self.showGroupsArray[indexPath.section].dataInSection[indexPath.row].showImage;
        //detailsVC.imageURL = self.series[indexPath.row].showImage;
        detailsVC.imageURL = imageURLFromGroups;
    
        //showID = [self.series[indexPath.row] getShowId];
    NSNumber *showIdFromGroups = [self.showGroupsArray[indexPath.section].dataInSection[indexPath.row] getShowId];
    showID = showIdFromGroups;
        
//    }
//    else if (indexPath.section == 1)
//    {
        //detailsVC.navigationItemTitle = self.movies[indexPath.row].movie;
        //detailsVC.imageURL = self.movies[indexPath.row].showImage;
        //showID = [self.movies[indexPath.row] getShowId];
        
//    }
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
    
//        if (indexPath.section == 0)
//        {
//            [self.series removeObjectAtIndex: indexPath.row];
//        }
//        else if (indexPath.section == 1)
//        {
//            [self.movies removeObjectAtIndex: indexPath.row];
//        }
        [self.showGroupsArray[indexPath.section].dataInSection removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
//    if ((sourceIndexPath.section == 0) && (destinationIndexPath.section == 0))
    if (sourceIndexPath.section == destinationIndexPath.section)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            TVSeries *objectToBeMoved = self.series[sourceIndexPath.row];
//            //[self.tableView beginUpdates];
//            [self.series removeObjectAtIndex:sourceIndexPath.row];
//            [self.series insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //[self.tableView endUpdates];
//                [self.tableView reloadData];
            Show* objectToBeMoved = self.showGroupsArray[sourceIndexPath.section].dataInSection[sourceIndexPath.row];
            
            [self.showGroupsArray[sourceIndexPath.section].dataInSection removeObjectAtIndex:sourceIndexPath.row];
            [self.showGroupsArray[sourceIndexPath.section].dataInSection insertObject: objectToBeMoved atIndex:destinationIndexPath.row];
//            });
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
    }
//    else if ((sourceIndexPath.section == 1) && (destinationIndexPath.section == 1))
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            Movie *objectToBeMoved = self.movies[sourceIndexPath.row];
//            //[self.tableView beginUpdates];
//            [self.movies removeObjectAtIndex:sourceIndexPath.row];
//            [self.movies insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //[self.tableView endUpdates];
//                [self.tableView reloadData];
//            });
//        });
//    }
    
    else
    {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.tableView reloadData];
            
        }];
        NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
        [alertActions addObject:actionOK];
        
        UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Attention!" andMessage:@"You can not move shows between sections" andActions:alertActions];
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
//        if (indexPath.section == 0) {
//
//            [cell setupCellPropertiesWithObject:self.series[indexPath.row]];
//            cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];//TO
//            //cell.showsTitleDescription.text = [self.shows[indexPath.row] getSummary];
//            cell.layer.cornerRadius = 10;
//        }
//        else if (indexPath.section == 1)
//        {
//
//            [cell setupCellPropertiesWithObject:self.movies[indexPath.row]];
//            cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
//            cell.layer.cornerRadius = 10;
//
//        }

        [cell setupCellPropertiesWithObject:
            self.showGroupsArray[indexPath.section].dataInSection[indexPath.row]];
        
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
#pragma mark -Get TV genre id and name
-(void) getTVGenreNameAndGenreId
{
    [self.tvGenres removeAllObjects];
    [self.tvGenresDictionary removeAllObjects];
    
    NSString *moviesGenreQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/genre/tv/list?api_key=6b2e856adafcc7be98bdf0d8b076851c&language=en-US"];
    
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
                if (dict[@"id"]) {
                    if (dict[@"name"]){
                        genreModel = [[AFSEGenreModel alloc] initWithGenreID:dict[@"id"]
                                                                andGenreName:dict[@"name"]];
                    }
                }
                NSString *genreKey = [NSString stringWithFormat:@"%@", genreModel.genreID];
                [self.tvGenresDictionary setValue:genreModel.genreName forKey:genreKey];
                [self.showGenresDictionary setValue:genreModel.genreName forKey:genreKey];
                [self.tvGenres addObject:genreModel];
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
}

#pragma mark -Get Movie genre id and name
-(void) getMovieGenreNameAndGenreId
{
    [self.movieGenres removeAllObjects];
    [self.movieGenresDictionary removeAllObjects];
    
    NSString *moviesGenreQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/genre/movie/list?api_key=6b2e856adafcc7be98bdf0d8b076851c&language=en-US"];
    
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
                if (dict[@"id"]) {
                    if (dict[@"name"]){
                    genreModel = [[AFSEGenreModel alloc] initWithGenreID:dict[@"id"]
                                                            andGenreName:dict[@"name"]];
                    }
                }
                NSString *genreKey = [NSString stringWithFormat:@"%@", genreModel.genreID];
                [self.movieGenresDictionary setValue:genreModel.genreName forKey:genreKey];
                [self.showGenresDictionary setValue:genreModel.genreName forKey:genreKey];
                [self.movieGenres addObject:genreModel];
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
}


#pragma mark -Fetch API
-(void)fetchNewRemoteJSONWithSearchText: (NSString *)userSearchText
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
                    //[self.shows addObject:tvSerie];
                    [self.shows addObject:showInfo];
                }
                else if ([dict[@"media_type"] isEqualToString:@"movie"])
                {
                    
                    showMovie = [[Movie alloc] initWithResponseDictionaryFromTvDb:dict];
                    [self.movies addObject: showMovie];
                    [self.shows addObject:showMovie];
                }
            }
            
            [self groupItemsBasedOnGenreId];
            
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
#pragma mark -Group shows on genre
- (void) groupItemsBasedOnGenreId
{
    self.showGroupsArray = [[NSMutableArray alloc] init];
    BOOL onList = NO;
    
    for (Show *show in self.shows)
    {
        for (int i = 0; i < self.showGroupsArray.count; i++)
        {
            if ([show.showGenreID isEqual:self.showGroupsArray[i].sectionID])
            {
                [self.showGroupsArray[i].dataInSection addObject:show];
                onList = YES;
                break;
            }
        }
        if(onList == NO)
        {
            
            AFSEShowGroup *showGroup = [[AFSEShowGroup alloc] initWithSectionID:show.showGenreID];
            [showGroup.dataInSection addObject:show];
            [self.showGroupsArray addObject:showGroup];
        }
            onList = NO;
        
    }
}

- (NSArray*)matchIdsWithNamesFromDictionary: (NSDictionary *)dict
{
    NSMutableArray *titleNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.showGroupsArray.count; i++)
    {
        
        for (NSString *key in [dict allKeys])
        {
            NSNumber *keyNumber = @([key intValue]);
            if ([self.showGroupsArray[i].sectionID isEqual:keyNumber])
            {
                [titleNames addObject:dict[key]];
            }
        }
    }
    NSArray *genreTitles = [[NSArray alloc] initWithArray:titleNames];
    return genreTitles;
}

@end


