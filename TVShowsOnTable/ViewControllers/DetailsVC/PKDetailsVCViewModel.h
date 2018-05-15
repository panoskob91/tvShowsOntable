//
//  PKDetailsVCViewModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsViewController.h"
#import "Show.h"

@interface PKDetailsVCViewModel : NSObject

@property (strong, nonatomic) NSString *showSumary;
@property (strong, nonatomic) NSString *imageUrlPath;
@property (strong, nonatomic) NSString *showTypeImageName;

- (instancetype)initWithObject:(Show *)showObject;

- (void)setupImageViewsFromVC:(DetailsViewController *)detailsVC
                   WithObject:(PKDetailsVCViewModel *)viewModelObject;
- (void)setupDetailsTextViewFromVC:(DetailsViewController *)detailsVC
                        WithString:(NSString *)showSummary;

@end
