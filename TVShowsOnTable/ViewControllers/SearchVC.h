//
//  ViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

//Table cell class
#import "TVShowsCell.h"
//View controllers
#import "DetailsViewController.h"
#import "PickShowTypeVC.h"
//Model header file
#import "Show.h"
#import "Movie.h"
//Helpers
#import "NSString_stripHtml.h"
//Categories and protocols
#import "myViewDelegate.h"

@interface SearchVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, myViewDelegate>

#pragma mark -SearchVC property
@property (strong, nonatomic) NSString *searchedText;

//- (void)parseLocalJSONFileWithName: (NSString *)fileName;

/**
 TV maze API parsing function. GET Request type used. Data is stored in a Show Class array object

 @param userSearchText Takes user input as a parameters
 */
//- (void) fetchRemoteJSONWithSearchText: (NSString *)userSearchText;

@end

