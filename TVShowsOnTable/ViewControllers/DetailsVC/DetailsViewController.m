//
//  DetailsViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

//ViewControllers
#import "DetailsViewController.h"
#import "AFSEWebContentHandlerVC.h"
//Networking
#import "PKNetworkManager.h"
//View models

//Cell classes
#import "PKImagesCellDetailsVC.h"
#import "PKSummaryCellDetailsVC.h"

@interface DetailsViewController ()

@property (strong, nonatomic) NSNumber *showID;

@property (strong, nonatomic) NSString *showSummary;

@end

@implementation DetailsViewController

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    
    //Network manager work
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchDescriptionFromId:self.showID
                              andMediaType:self.show.mediaType];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark -Networking delegate methods
- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    
}

- (void)APIFetchedWithResponseDescriptionProperty:(NSString *)showSummary
{
    self.showSummary = showSummary;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.detailsTableView reloadData];
    });
}

#pragma mark -Gesture events handler(s)
//Image tap event handler
- (void)handleSingleTap
{
    [self performSegueWithIdentifier:@"webViewSegue" sender:self];
}

- (void)setupNavigationItem
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Details", self.navigationItemTitle];
}

#pragma mark -Getters
- (NSNumber *)getTheShowID
{
    return self.showID;
}

- (NSString *)getShowSummary
{
    return self.showSummary;
}

#pragma mark -Setters
- (void)setTheShowID:(NSNumber *)SID
{
    self.showID = [[NSNumber alloc] init];
    self.showID = SID;
}

@end
