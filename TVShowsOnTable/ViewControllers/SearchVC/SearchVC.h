//
//  ViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
//Categories and protocols
#import "ButtonEventHandlingDelegate.h"
#import "AFSENetworkingDelegate.h"
//View models
#import "PKShowTableCellViewModel.h"

@interface SearchVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ButtonEventHandlingDelegate, AFSENetworkingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark -SearchVC properties
/**
 User typed text
 */
@property (strong, nonatomic) NSString *searchedText;
@property (strong, nonatomic) NSArray <NSArray <PKShowTableCellViewModel *> *> *sections;

/**
 ViewModel update UI
 */
- (void)updateContent;
- (NSArray <NSArray <PKShowTableCellViewModel *> *> *)getSectionsArray;

@end

