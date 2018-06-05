//
//  FavoritesHandlingDelegate.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
#import "Show.h"
#import "PKSummaryCellDetailsVC.h"

//@class PKSummaryCellDetailsVC;
@protocol FavoritesHandlingDelegate <NSObject>

@optional
- (void)didAdd:(Show *)show ToList:(List *)list;
- (void)didRemove:(Show *)show FromList:(List *)list;

- (void)addButtonWasPressedFromCell:(PKSummaryCellDetailsVC *)cell;
- (void)removeButtonWasPressedFromCell:(PKSummaryCellDetailsVC *)cell;

@end
