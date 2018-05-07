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

@property (strong, nonatomic) NSString *labelValue;
@property (strong, nonatomic) NSString *navigationItemTitle;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSNumber *dataToBePassedOnDetailsVC;
@property (strong, nonatomic) Show *show;

#pragma mark -Getters
- (NSNumber *)getTheShowID;

#pragma mark -Setters
- (void)setTheShowID: (NSNumber *)SID;

@end
