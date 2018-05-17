//
//  AFSETvMazeDetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSETvMazeDetailsVC.h"

@interface AFSETvMazeDetailsVC ()

@property (strong, nonatomic) IBOutlet UIImageView *tvMazeDetailsImageView;
@property (strong, nonatomic) IBOutlet UITextView *tvMazeDetailsTextView;

@end

@implementation AFSETvMazeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *imageUrl = [NSURL URLWithString:self.imageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    self.tvMazeDetailsImageView.image = [UIImage imageWithData:imageData];
    self.tvMazeDetailsTextView.text = self.detailsText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
