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


@interface SearchVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ButtonEventHandlingDelegate>

#pragma mark -SearchVC properties
@property (strong, nonatomic) NSString *searchedText;

@end

