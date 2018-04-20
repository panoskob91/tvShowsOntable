//
//  DetailsViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionDetailsTextView.text = self.labelValue;
    self.descriptionDetailsTextView.editable = NO;
    [self.descriptionDetailsTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    self.descriptionDetailsTextView.textColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.21 green:0.5 blue:0.48 alpha:1];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
    self.showImageView.image = [UIImage imageWithData:imageData];
    self.showImageView.layer.cornerRadius = 10;
    self.showImageView.contentMode = UIViewContentModeScaleToFill;
    self.showImageView.clipsToBounds = YES;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePitchGesture:)];
    //[self.showImageView addGestureRecognizer: pinchGesture];
    [self.view addGestureRecognizer: pinchGesture];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Details", self.navigationItemTitle];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePitchGesture: (UIPinchGestureRecognizer *)gestureRecogniser
{
    
    UIGestureRecognizerState state = [gestureRecogniser state];
    CGFloat initialScale = [gestureRecogniser scale];
    
    if  (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [gestureRecogniser scale];
        [gestureRecogniser.view setTransform:CGAffineTransformScale(gestureRecogniser.view.transform, scale, scale)];
        [gestureRecogniser setScale:1];
    }else if (state == UIGestureRecognizerStateEnded)
    {
        [gestureRecogniser setScale:initialScale];
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
