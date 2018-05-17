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
    //[self setupTextView];
    //[self setupImageViews];
    [self setupNavigationItem];
    
    //Table view setup
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCImagesCell" bundle:nil] forCellReuseIdentifier:@"detailsVCimagesCell"];
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCDescription" bundle:nil] forCellReuseIdentifier:@"detailsVCDetailsCell"];
    self.detailsTableView.tableFooterView = [[UIView alloc] init];
    
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
        NSURL *imageURL = [NSURL URLWithString:self.show.showImageUrlPath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        imagesCell.mainImageDetailsVC.image = [UIImage imageWithData:imageData];
        NSString *mediaTypeImageindicatorName = [detailsVCViewModel getMediaTypeImageIndicatorNameFromObject:self.show];
        imagesCell.mediaTypeImageIndicator.image = [UIImage imageNamed:mediaTypeImageindicatorName];
        
        return imagesCell;
    }
    
        PKSummaryCellDetailsVC *detailsCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsSummaryCellIdentifier]];
        detailsCell.detailsCellDescriptionLabel.text = self.showSummary;
        
        return detailsCell;
   
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webViewSegue"])
    {
        AFSEWebContentHandlerVC *webHandlerVC = segue.destinationViewController;
        webHandlerVC.show = self.show;
        webHandlerVC.showIdentifier = self.showID;
    }
}

//- (void)setupTextView
//{
//    self.descriptionDetailsTextView.text = self.labelValue;
//    self.descriptionDetailsTextView.editable = NO;
//    [self.descriptionDetailsTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
//    self.descriptionDetailsTextView.textColor = [UIColor blackColor];
//}

- (void)setupNavigationItem
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Details", self.navigationItemTitle];
}

//- (void)setupImageViews
//{
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
//    self.showImageView.image = [UIImage imageWithData:imageData];
//    self.showImageView.layer.cornerRadius = 10;
//    self.showImageView.contentMode = UIViewContentModeScaleToFill;
//    self.showImageView.clipsToBounds = YES;
//    if ([self.show.mediaType isEqualToString:@"tv"])
//    {
//        self.mediaTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
//    }
//    else if ([self.show.mediaType isEqualToString:@"movie"])
//    {
//        self.mediaTypeImageView.image = [UIImage imageNamed:@"movieImage"];
//    }
//}

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
