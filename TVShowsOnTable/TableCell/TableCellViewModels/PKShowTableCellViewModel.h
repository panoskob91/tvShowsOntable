//
//  PKShowTableCellViewModel.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"
#import "TVShowsCell.h"

@interface PKShowTableCellViewModel : NSObject

/**
 Show's title
 */
@property (strong, nonatomic) NSString *showViewModelTitle;

/**
 show's image url path
 */
@property (strong, nonatomic) NSString *showViewModelImageURL;

/**
 Show's average rating
 */
@property (strong, nonatomic) NSString *showViewModelAveragerating;

- (instancetype)initWithShowViewModelObject:(Show *)showObject;

- (NSString *)getCellIdentifier;
- (void)updateView:(TVShowsCell *)cell;


@end
