//
//  DetailsViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "DetailsViewController.h"
#import "AFSEWebContentHandlerVC.h"
#import "PKNetworkManager.h"
#import "PKDetailsVCViewModel.h"

@interface DetailsViewController ()


@property (strong, nonatomic) NSNumber *showID;

@end

@implementation DetailsViewController

NSString *summary;

#pragma mark -ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupTextView];
    //[self setupImageViews];
    [self setupNavigationItem];
    
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchDescriptionFromId:self.showID
                              andMediaType:self.show.mediaType];
    
    PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show];
    [detailsVCViewModel setupImageViewsFromVC:self WithObject:detailsVCViewModel];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap)];
    singleFingerTap.numberOfTouchesRequired = 1;
    [self.showImageView setUserInteractionEnabled:YES];
    [self.showImageView addGestureRecognizer:singleFingerTap];
    
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
