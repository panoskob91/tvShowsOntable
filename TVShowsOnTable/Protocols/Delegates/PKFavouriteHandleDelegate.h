//
//  FavoriteHandleDelegate.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 04/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"
#import "List.h"

@protocol PKFavouriteHandleDelegate <NSObject>

@optional
- (void)userDidAdd:(Show *)show ToFavorites:(List *)list;
- (void)userDidRemove:(Show *)show FromFavorites:(List *)list;

@end
