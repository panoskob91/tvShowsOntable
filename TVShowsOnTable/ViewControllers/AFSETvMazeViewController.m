//
//  AFSETvMazeViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSETvMazeViewController.h"
#import "Show.h"
#import "Movie.h"
#import "TVShowsCell.h"
#import "AFSETvMazeDetailsVC.h"

@interface AFSETvMazeViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *tvMazeSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tvMazeTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tvMazeActivityIndicator;

@property (strong, nonatomic) NSMutableArray<Movie *> *shows;

- (void)fetchRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

@implementation AFSETvMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shows = [[NSMutableArray alloc] init];
    
    self.tvMazeTableView.delegate = self;
    self.tvMazeTableView.dataSource = self;
    self.tvMazeSearchBar.delegate = self;
    
    self.tvMazeTableView.tableFooterView = [[UIView alloc] init];
    self.tvMazeActivityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self fetchRemoteJSONWithSearchText: self.tvMazeSearchBar.text];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFSETvMazeDetailsVC *tvMazeDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tvMazeDetailsVC"];
    tvMazeDetailsVC.detailsText = [self.shows[indexPath.row] getSummary];
    tvMazeDetailsVC.imageURL = self.shows[indexPath.row].showImage;
    
    [self.navigationController pushViewController:tvMazeDetailsVC animated:YES];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tvMazeTableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tVShowsCell"];
    if (indexPath.row <= self.shows.count && self.shows.count != 0){
        cell.showTitleLabel.text = self.shows[indexPath.row].showTitle;
        
        NSURL *imageURL = [NSURL URLWithString:self.shows[indexPath.row].showImage];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        cell.TVShowsImage.image = [UIImage imageWithData:imageData];
        
        cell.averageRating.text = [NSString stringWithFormat:@"%@", self.shows[indexPath.row].showAverageRating];
    }
    return cell;
}



- (void)fetchRemoteJSONWithSearchText: (NSString *)userSearchText
{
    [self.shows removeAllObjects];
    
    self.tvMazeActivityIndicator.hidden = NO;
    [self.tvMazeActivityIndicator startAnimating];
    
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
                //[self.shows addObject:showInfo];
            }
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tvMazeTableView reloadData];
            [self.tvMazeActivityIndicator stopAnimating];
            self.tvMazeActivityIndicator.hidden = YES;
            
        });
    }];
    [dataTask resume];
}


@end
