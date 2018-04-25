//
//  DetailsViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *labelValue;
@property (strong, nonatomic) NSString *navigationItemTitle;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSNumber *dataToBePassedOnDetailsVC;

#pragma mark -Getters
- (NSNumber *) getTheShowID;

#pragma mark -Setters
- (void) setTheShowID: (NSNumber *)SID;

@end
