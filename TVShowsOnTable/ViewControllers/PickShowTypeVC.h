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

@property (strong, nonatomic) IBOutlet UIButton *tvShowButton;
@property (strong, nonatomic) IBOutlet UIButton *movieButton;
- (IBAction)tvShowButtonPressed:(id)sender;
- (IBAction)movieButtonPressed:(id)sender;

@property (weak, nonatomic) id<ButtonEventHandlingDelegate> delegate;

@end
