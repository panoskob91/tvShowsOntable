//
//  DetailsViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionDetailsTextView;

@property (strong, nonatomic) NSString *labelValue;
@property (strong, nonatomic) NSString *navigationItemTitle;
@property (strong, nonatomic) NSString *imageURL;

@end
