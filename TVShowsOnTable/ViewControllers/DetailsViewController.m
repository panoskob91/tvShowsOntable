//
//  DetailsViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionDetailsTextView;

@property (strong, nonatomic) NSNumber *showID;

@end

@implementation DetailsViewController

NSString *summary;

#pragma mark -View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextView];
    [self setupImageView];
    [self setupNavigationItemStyle];
    [self fetchDescriptionFromId:self.showID];//Fetch data from API call
        
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer: pinchGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextView
{
    self.descriptionDetailsTextView.text = self.labelValue;
    self.descriptionDetailsTextView.editable = NO;
    [self.descriptionDetailsTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    self.descriptionDetailsTextView.textColor = [UIColor blackColor];
}

- (void)setupNavigationItemStyle
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Details", self.navigationItemTitle];
}

- (void)setupImageView
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
    self.showImageView.image = [UIImage imageWithData:imageData];
    self.showImageView.layer.cornerRadius = 10;
    self.showImageView.contentMode = UIViewContentModeScaleToFill;
    self.showImageView.clipsToBounds = YES;
}

- (void)handlePinchGesture: (UIPinchGestureRecognizer *)gestureRecogniser
{
    UIGestureRecognizerState state = [gestureRecogniser state];
    CGFloat initialScale = [gestureRecogniser scale];
    if  (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [gestureRecogniser scale];
        [gestureRecogniser.view setTransform:CGAffineTransformScale(gestureRecogniser.view.transform, scale, scale)];
        [gestureRecogniser setScale:1];
    }
    else if (state == UIGestureRecognizerStateEnded)
    {
        [gestureRecogniser setScale:initialScale];
    }
    
    
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

#pragma mark -Fetching
- (void)fetchDescriptionFromId: (NSNumber *)showId
{
    
    NSString *userSearchQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=6b2e856adafcc7be98bdf0d8b076851c", showId];
    NSURL *searchURL = [NSURL URLWithString:userSearchQuery];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
    NSURLSession *session = [NSURLSession sharedSession];
    summary = [[NSString alloc] init];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];

            NSString *responseSummary = responseDictionary[@"overview"];
            if ([responseSummary isEqual:[NSNull null]]
                || [responseSummary isEqualToString:@""])
            {
                summary = @"No summary available";
            }
            else
            {
                summary = responseSummary;
            }
            
        }
        else{
            NSLog(@"ERROR %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.descriptionDetailsTextView.text = summary;
        
        });
    }];
    [dataTask resume];
}

@end
