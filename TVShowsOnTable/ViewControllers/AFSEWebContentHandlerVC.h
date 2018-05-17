//
//  AFSEWebContentHandlerVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "AFSENetworkingDelegate.h"

@interface AFSEWebContentHandlerVC : UIViewController<AFSENetworkingDelegate>

/**
 Property holding the show Id when passed from the previous view controller
 */
@property (strong, nonatomic) NSNumber *showIdentifier;

/**
 A Show object passed from previous view controller needed from fetching needed information from the movie db API
 */
@property (strong, nonatomic) Show *show;

@end
