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
#import "PKDetailsVCViewModel.h"
//Cell classes
//#import "TVShowsCell.h"
#import "PKImagesCellDetailsVC.h"
#import "PKSummaryCellDetailsVC.h"

@interface DetailsViewController ()

@property (strong, nonatomic) NSNumber *showID;

@property (strong, nonatomic) NSString *showSummary;

@end

@implementation DetailsViewController

NSString *summary;

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    
    //Table view setup
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCImagesCell" bundle:nil] forCellReuseIdentifier:@"detailsVCimagesCell"];
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCDescription" bundle:nil] forCellReuseIdentifier:@"detailsVCDetailsCell"];
    self.detailsTableView.tableFooterView = [[UIView alloc] init];
    //Network manages work
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchDescriptionFromId:self.showID
                              andMediaType:self.show.mediaType];
    
    PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show];
    [detailsVCViewModel setupImageViewsFromVC:self
                                   WithObject:detailsVCViewModel];
    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap)];
//    singleFingerTap.numberOfTouchesRequired = 1;
//    [self.showImageView setUserInteractionEnabled:YES];
//    [self.showImageView addGestureRecognizer:singleFingerTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -Table view functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show];
    
    if (indexPath.row == 0)
    {
        PKImagesCellDetailsVC *imagesCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsImagesCellIdentifier]];
        [detailsVCViewModel updateImagesCell:imagesCell];
        
        return imagesCell;
    }
    
    PKSummaryCellDetailsVC *detailsCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsSummaryCellIdentifier]];
    [detailsVCViewModel updateDetailsCell:detailsCell];
    
        return detailsCell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"webViewSegue" sender:self];
    }
    
}

#pragma mark -Networking delegate methods
- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    
}

- (void)APIFetchedWithResponseDescriptionProperty:(NSString *)showSummary
{
    //self.showSummary = [[NSString alloc] init];
    self.showSummary = showSummary;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.descriptionDetailsTextView.text = showSummary;
        PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show];
        [detailsVCViewModel setupDetailsTextViewFromVC:self WithString:showSummary];
    });
}

#pragma mark -Gesture events handler(s)
//Image tap event handler
- (void)handleSingleTap
{
    [self performSegueWithIdentifier:@"webViewSegue" sender:self];
}

#pragma mark -Segue setup
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webViewSegue"])
    {
        AFSEWebContentHandlerVC *webHandlerVC = segue.destinationViewController;
        webHandlerVC.show = self.show;
        webHandlerVC.showIdentifier = self.showID;
    }
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

#pragma mark -Setters
- (void)setTheShowID:(NSNumber *)SID
{
    self.showID = [[NSNumber alloc] init];
    self.showID = SID;
}

@end
