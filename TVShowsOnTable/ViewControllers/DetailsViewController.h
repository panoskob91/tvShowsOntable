//
//  DetailsViewController.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detailsViewInfoLabel;
@property (strong, nonatomic) NSString *labelValue;

@end
