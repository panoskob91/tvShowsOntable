//
//  ViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShowsCell.h"
#import "DetailsViewController.h"
#import "Show.h"
#import "Movie.h"
#import "NSString_stripHtml.h"
#import "PickShowTypeVC.h"
#import "myViewDelegate.h"

@interface SearchVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, myViewDelegate>
#pragma mark -IBoutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *shows;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableViewActivityindicator;

#pragma mark -SearchVC property
@property (strong, nonatomic) NSString *searchedText;

//- (void)parseLocalJSONFileWithName: (NSString *)fileName;

/**
 TV maze API parsing function. GET Request type used. Data is stored in a Show Class array object

 @param userSearchText Takes user input as a parameters
 */
- (void) fetchRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

