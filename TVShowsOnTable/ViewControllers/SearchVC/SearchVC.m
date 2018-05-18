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
@property (strong, nonatomic) NSMutableArray<PKShowTableCellViewModel *> *viewModelGroups;
@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroups;

//@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroupsArray;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *movieGenres;
@property (strong, nonatomic) NSMutableArray<AFSEGenreModel *> *tvGenres;
@property (strong, nonatomic) NSMutableDictionary *movieGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *tvGenresDictionary;
@property (strong, nonatomic) NSMutableDictionary *showGenresDictionary;
@property (nonatomic, assign) BOOL contentIsEditable;

//IBOutlets

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
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
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
    self.genreNames = [[NSArray alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    self.viewModelGroups = [[NSMutableArray alloc] init];
    
    NSMutableArray *sectionParent = [[NSMutableArray alloc] init];
    
    for (AFSEShowGroup *showGroup in self.showGroupsArray)
    {
        NSMutableArray *currentSection = [[NSMutableArray alloc] init];
        for (Show *show in showGroup.dataInSection)
        {
            PKShowTableCellViewModel *showCellVM = [[PKShowTableCellViewModel alloc] initWithShowViewModelObject: show];
            [currentSection addObject:showCellVM];
        }
        [sectionParent addObject:currentSection];
    }
    self.sections = [[NSArray alloc] initWithArray:sectionParent.copy];
    self.genreNames = [self getGenreNamesFromSectionsArrrayAndFromGenresDictionary:self.showGenresDictionary];
    [self.tableView reloadData];
}


#pragma mark -Geters
- (NSArray<NSString *> *)getGenreNamesFromSectionsArrrayAndFromGenresDictionary:(NSDictionary *)dict
{
    NSMutableArray *genreTitles = [[NSMutableArray alloc] init];
    for (NSArray<PKShowTableCellViewModel *> *sectionItemArray in self.sections)
    {
        for (PKShowTableCellViewModel *sectionItem in sectionItemArray) {
            for (NSString *dictionaryKey in dict) {
                NSNumber *genreDictionaryKeyValue = @([dictionaryKey integerValue]);
                if ([sectionItem.showViewModelGenreID isEqual:genreDictionaryKeyValue] &&
                    ![genreTitles containsObject:dict[dictionaryKey]])
                {
                    [genreTitles addObject:dict[dictionaryKey]];
                    break;
                }

            }
        }
    }
    NSArray *genreNames = [[NSArray alloc] initWithArray:genreTitles];
    return genreNames;
}

- (NSArray <NSArray <PKShowTableCellViewModel *> *> *)getSectionsArray
{
    return self.sections;
}

- (NSArray<Show *> *)getShowsArray
{
    return self.showsArray;
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


