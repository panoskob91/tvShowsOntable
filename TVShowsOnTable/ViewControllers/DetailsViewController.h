//
//  DetailsViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFSENetworkingDelegate.h"
#import "Show.h"

@interface DetailsViewController : UIViewController<AFSENetworkingDelegate>

/**
 Placeholder for show description
 */
@property (strong, nonatomic) NSString *labelValue;

/**
 Placeholder for navigation title
 */
@property (strong, nonatomic) NSString *navigationItemTitle;

/**
 Placeholder which gets the image url path from searchVC
 */
@property (strong, nonatomic) NSString *imageURL;

/**
 Show object needed for API fetching
 */
@property (strong, nonatomic) Show *show;

#pragma mark -Getters

/**
Private showId property getter instance method

 @return NSNumber representing showID
 */
- (NSNumber *)getTheShowID;

#pragma mark -Setters
/**
 Private showId property setter instance method
 
 */
- (void)setTheShowID: (NSNumber *)SID;

@end
