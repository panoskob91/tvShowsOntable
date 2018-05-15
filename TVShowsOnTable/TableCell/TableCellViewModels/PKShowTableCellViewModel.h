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
#import "AFSEShowGroup.h"

@interface PKShowTableCellViewModel : NSObject

@property (strong, nonatomic) Show *bindModel;
@property (strong, nonatomic) AFSEShowGroup *showGroup;

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
@property (strong, nonatomic) NSString *showViewModelAverageRating;

- (instancetype)initWithShowViewModelObject:(Show *)showObject;
- (instancetype)initWithShowViewModelObject:(Show *)showObject
                         andShowGroupObject:(AFSEShowGroup *)showGroupObject;

- (NSString *)getCellIdentifier;
- (void)updateView:(TVShowsCell *)cell;

@end
