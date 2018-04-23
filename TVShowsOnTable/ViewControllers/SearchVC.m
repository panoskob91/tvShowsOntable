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

@interface SearchVC ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;
- (IBAction)pickShowVCButtonPSD:(id)sender;

@end

@implementation SearchVC

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"Shows";
    
    //Initialise shows array
    self.shows = [[NSMutableArray alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    self.searchedText = [[NSString alloc] init];
    
    self.tableViewActivityindicator.hidden = YES;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //Movie *movieObject = [[Movie alloc] init];
    self.searchedText = self.searchBar.text;
    [self fetchRemoteJSONWithSearchText:self.searchedText];
    //self.shows = [movieObject parseRemoteJSONWithSearchText: self.searchedText];
    //NSLog(@"shows %@", self.shows);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    //detailsViewController.detailsViewInfoLabel.text = self.showDescription[indexPath.row];
    
    
}
#pragma mark -UITTableView delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVShowsCell"];
    
    if (indexPath.row <= self.shows.count && self.shows.count != 0){
    
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
        return cell;
    
}

#pragma mark -Segues managments
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *detailsVC = segue.destinationViewController;
        detailsVC.labelValue = [self.shows[indexPath.row] getSummary];//Read summary from a private property
        detailsVC.imageURL = self.shows[indexPath.row].showImage;
        detailsVC.navigationItemTitle = self.shows[indexPath.row].showTitle;
        
    }
    
}

#pragma mark -UITableView footer
//remove bottom lines
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [UIView new];
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

- (void) activityIndicatorHandlerWhenActivityIndicatorIs:
(BOOL)activityIndicatorIsHidden
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Button pressed info" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK button pressed");
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel pressed");
    }];
    [actionCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [actionOK setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
    [alert addAction:actionOK];
    [alert addAction:actionCancel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

@end


