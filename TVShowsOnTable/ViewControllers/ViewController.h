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

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *searchedText;

- (void)parseLocalJSONFileWithName:(NSString *)fileName;
- (void)parseRemoteJSONWithSearchText: (NSString *)userText;

@end

