//
//  SearchViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 11/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.searchBar.delegate = self;
    //self.searchBar.backgroundColor = [UIColor lightGrayColor];
    self.searchBar.textColor = [UIColor blackColor];
    self.searchBar.placeholder = @"Search";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"tableViewSegue"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.searchedText = self.searchBar.text;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"tableViewSegue" sender:self];
//    ViewController *vc = [[ViewController alloc] init];
//    vc.shows = [[NSMutableArray alloc] init];
    [_searchBar resignFirstResponder];
    return YES;
}


- (IBAction)searchButtonPressed:(id)sender {
    
//    ViewController *vc = [[ViewController alloc] init];
//    vc.shows = [[NSMutableArray alloc] init];
    [_searchBar resignFirstResponder];
}

@end
