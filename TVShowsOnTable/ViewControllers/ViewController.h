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


@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *searchedText;
//@property (strong, nonatomic) NSMutableArray<Show *> *shows;
@property (strong, nonatomic) NSMutableArray<Movie *> *shows;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


//- (void)parseLocalJSONFileWithName: (NSString *)fileName;
- (void)parseRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

