//
//  ViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "SearchVC.h"

//Model header files
#import "Show.h"
#import "Movie.h"
#import "TVSeries.h"
#import "PKNetworkManager.h"

//View models
#import "PKMovieCellViewModel.h"


//Helpers
#import "NSString_stripHtml.h"
//Categories and protocols
#import "UIAlertController+AFSEAlertGenerator.h"
//View controllers
#import "DetailsViewController.h"
#import "PickShowTypeVC.h"
//Data grouping
#import "AFSEShowGroup.h"
#import "AFSEGenreModel.h"
//Table cell class
#import "TVShowsCell.h"

@interface SearchVC ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;
@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;
@property (strong, nonatomic) NSMutableArray<TVSeries *> *series;
@property (strong, nonatomic) NSArray<Show *> *showsArray;

@property (strong, nonatomic) NSMutableArray<PKShowTableCellViewModel *> *viewModels;
@property (strong, nonatomic) NSArray<PKShowTableCellViewModel *> *viewModelGroups;
@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroups;
@property (strong, nonatomic) NSArray<NSString *> *genreNames;

@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroupsArray;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *movieGenres;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *tvGenres;
@property (strong, nonatomic) NSMutableDictionary *movieGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *tvGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *showGenresDictionary;
@property (nonatomic, assign) BOOL contentIsEditable;

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableViewActivityindicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *enableEditBTN;

- (IBAction)pickShowVCButtonPSD:(id)sender;
- (IBAction)enableEditButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation SearchVC

NSMutableDictionary *showsDataDictionary;
NSArray *selectedCells;


#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupSearchBar];
    [self initialiseTheNeededArrays];
    [self getMovieGenreNameAndGenreId];
    [self getTVGenreNameAndGenreId];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
    
    self.title = @"Shows";
    self.contentIsEditable = true;
    self.tableViewActivityindicator.hidden = YES;
}

- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    self.showsArray = [[NSArray alloc] initWithArray:shows];
    [self groupItemsBasedOnGenreIdWithDataFromArray:self.showsArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateContent];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    showsDataDictionary = [[NSMutableDictionary alloc] init];
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
    //Search bar style
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
}
#pragma mark -SearchBar delegate functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchedText = self.searchBar.text;
    //[self fetchNewRemoteJSONWithSearchText:self.searchedText];
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchAPICallWithSearchText:self.searchedText];
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

#pragma mark -Update ViewModels
- (void)updateContent
{
    self.viewModels = [[NSMutableArray alloc] init];
    self.genreNames = [[NSMutableArray alloc] init];
    //self.sections = [[NSMutableArray alloc] init];
    
    NSMutableArray *sectionParent = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.showsArray.count; i++) {
        Show *show = self.showsArray[i];
        PKShowTableCellViewModel *showViewModel = [[PKShowTableCellViewModel alloc] initWithShowViewModelObject:show];
        showViewModel.showViewModelGenreName = [showViewModel getGenreNameBasedOnGenreIdFromDicrionary:self.showGenresDictionary];
        
        NSMutableArray *currentSection = [[NSMutableArray alloc] init];
        PKShowTableCellViewModel *showCellViewModel = [[PKShowTableCellViewModel alloc] initWithShowViewModelObject:show];
        [currentSection addObject:showCellViewModel];
        [sectionParent addObject:currentSection];
        self.sections = [[NSArray alloc] initWithArray:sectionParent];
        
        [self.viewModels addObject:showViewModel];
    }
    
//    NSArray *genreNamesArray = [PKShowTableCellViewModel matchIdsWithNamesFromDictionary:self.showGenresDictionary
//                                                                          andSourceArray:self.viewModels];
//    self.genreNames = genreNamesArray;
//    self.viewModelGroups = [PKShowTableCellViewModel getGroupedArrayFromViewModelsArray:self.viewModels
//                                                                     andGenreNamesArray:self.genreNames];
    [self.tableView reloadData];
}

#pragma mark -UITableView Data source functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary];
    //return genreNames.count;
    //return self.viewModels.count;
    return 1;
//    return self.genreNames.count;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary];
    //return genreNames[section];
    return @"KITSOS";
    
//    return self.genreNames[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.showGroupsArray[section].dataInSection.count;
    return self.viewModels.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    selectedCells = [self.tableView indexPathsForSelectedRows];
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    Show *show = self.showGroupsArray[indexPath.section].dataInSection[indexPath.row];
    NSNumber *showID = [[NSNumber alloc] init];
    NSString *showTitleFromGroups = show.showTitle;
        detailsVC.navigationItemTitle = showTitleFromGroups;
    NSString *imageURLFromGroups = show.showImageUrlPath;
        detailsVC.imageURL = imageURLFromGroups;
    NSNumber *showIdFromGroups = [show getShowId];
    showID = showIdFromGroups;
    
    detailsVC.show = show;
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
    if (UITableViewCellEditingStyleDelete)
    {
        NSMutableArray<Show *> *showsArray = self.showGroupsArray[indexPath.section].dataInSection;
        [showsArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Show *objectToBeMoved = self.showGroupsArray[sourceIndexPath.section].dataInSection[sourceIndexPath.row];
            NSMutableArray<Show *> *showsInSection = self.showGroupsArray[sourceIndexPath.section].dataInSection;
            [showsInSection removeObjectAtIndex:sourceIndexPath.row];
            [showsInSection insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
    }
    else
    {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView reloadData];
        }];
        NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
        [alertActions addObject:actionOK];
        
        //NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary];
        NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary andSourceArray:self.showGroupsArray];
        NSString *alertMessage = [NSString stringWithFormat:@"Sorry, you cannot move elements from section %@ to section %@",
                                  genreNames[sourceIndexPath.section], genreNames[destinationIndexPath.section]];

        UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Attention!" andMessage:alertMessage andActions:alertActions];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}

#pragma mark -UITTableView delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Show *show = self.showGroupsArray[indexPath.section].dataInSection[indexPath.row];
    //NSArray <Show *> *shows = [[NSArray alloc] initWithObjects:self.showGroupsArray[indexPath.section].dataInSection, nil] ;
    //PKShowTableCellViewModel *showViewModel = [[PKShowTableCellViewModel alloc] initWithShowViewModelObject:show];
    PKShowTableCellViewModel *showViewModel = self.viewModels[indexPath.row];
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:[showViewModel getCellIdentifier]];
    
//    if (indexPath.row <= shows.count
//        && shows.count != 0)
//    {
//        if ([show.mediaType isEqualToString:@"tv"])
//        {
//            cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
//        }
//        else if ([show.mediaType isEqualToString:@"movie"])
//        {
//            cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
//        }
        //[cell setupCellPropertiesWithObject:show];    
        [showViewModel updateView:cell];
//    }
        return cell;
}
#pragma mark -UITableView footer
//remove bottom lines
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView* footer = [UIView new];
    UIView *footer = [[UIView alloc] init];
    return footer;
}

#pragma mark -Get TV genre id and name
-(void)getTVGenreNameAndGenreId
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
- (void)getMovieGenreNameAndGenreId
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

- (void)activityIndicatorHandlerWhenActivityIndicatorIs: (BOOL)activityIndicatorIsHidden
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
- (void)groupItemsBasedOnGenreIdWithDataFromArray:(NSArray *)shows
{
    self.showGroupsArray = [[NSMutableArray alloc] init];
    self.viewModels = [[NSMutableArray alloc] init];
    BOOL onList = NO;
    
    for (Show *show in shows)
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

- (NSArray *)matchIdsWithNamesFromDictionary:(NSDictionary *)dict
                              andSourceArray:(NSArray<AFSEShowGroup *> *)sourceArray
{
    NSMutableArray *titleNames = [[NSMutableArray alloc] init];
    //for (int i = 0; i < self.showGroupsArray.count; i++)
    for (int i = 0; i < sourceArray.count; i++)
    {
        for (NSString *key in [dict allKeys])
        {
            NSNumber *keyNumber = @([key intValue]);
            //if ([self.showGroupsArray[i].sectionID isEqual:keyNumber])
            if ([sourceArray[i].sectionID isEqual:keyNumber])
            {
                [titleNames addObject:dict[key]];
            }
        }
    }
    NSArray *genreTitles = [[NSArray alloc] initWithArray:titleNames];
    return genreTitles;
}

@end


