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
//ViewControllers
#import "MasterTableVC.h"

//Delegates

@interface SearchVC : MasterTableVC<UISearchBarDelegate, ButtonEventHandlingDelegate, AFSENetworkingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

#pragma mark -SearchVC properties

/**
 User typed text
 */
@property (strong, nonatomic) NSString *searchedText;

//
///**
// The sections of the table view
// */
//@property (strong, nonatomic) NSArray <NSMutableArray <PKShowTableCellViewModel *> *> *sections;

/**
 Array holding grouped elements
 */
@property (strong, nonatomic) NSMutableArray<AFSEShowGroup *> *showGroupsArray;

/**
 Genre names to be used as section titles
 */
//@property (strong, nonatomic) NSArray<NSString *> *genreNames;
/**
 ViewModel update UI
 */
- (void)updateContent;

#pragma mark -Getters

/**
 Returns sections

 @return Array of arrays of type PKShowTableCellViewModel
 */
- (NSArray <NSArray <PKShowTableCellViewModel *> *> *)getSectionsArray;

- (NSArray<Show *> *)getShowsArray;

- (NSArray<NSString *> *)getGenreNamesFromSectionsArrrayAndFromGenresDictionary:(NSDictionary *)dict;

@end

