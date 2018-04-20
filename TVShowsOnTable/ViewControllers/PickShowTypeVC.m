//
//  PickShowTypeVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PickShowTypeVC.h"
#import "SearchVC.h"

@interface PickShowTypeVC ()

@end

@implementation PickShowTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)tvShowButtonPressed:(id)sender {

    
    [self.delegate pickShowTypeVC:self didSelectButton:sender];
    
}

- (IBAction)movieButtonPressed:(id)sender {

    
    [self.delegate pickShowTypeVC:self didSelectButton:sender];
    
}
@end
