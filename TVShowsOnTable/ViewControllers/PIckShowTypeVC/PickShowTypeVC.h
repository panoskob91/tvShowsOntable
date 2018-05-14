//
//  PickShowTypeVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonEventHandlingDelegate.h"

@interface PickShowTypeVC : UIViewController

/**
 TV button IBOutlet, representing TVSeries
 */
@property (strong, nonatomic) IBOutlet UIButton *tvShowButton;

/**
Movie button IBOutlet, representing TVSeries
 */
@property (strong, nonatomic) IBOutlet UIButton *movieButton;

/**
 TV button press event listener

 @param sender TV button
 */
- (IBAction)tvShowButtonPressed:(id)sender;

/**
 Movie button event listener

 @param sender Movie button
 */
- (IBAction)movieButtonPressed:(id)sender;


/**
 Delegation object for button event handling
 */
@property (weak, nonatomic) id<ButtonEventHandlingDelegate> delegate;

@end
