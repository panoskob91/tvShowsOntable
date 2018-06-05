//
//  PKFavouritesCellVM.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKFavouritesCell.h"
#import "Show.h"

@interface PKFavouritesCellVM : NSObject

@property (strong, nonatomic) NSString *favouriteShowTitle;
@property (strong, nonatomic) NSString *mainImageURL;
@property (strong, nonatomic) NSString *mediaTypeImageIndicatorName;
@property (strong, nonatomic) NSString *favoriteImageName;
@property (strong, nonatomic) id bindModel;

#pragma mark - Initialisers

- (instancetype)initWithFavouriteShowTitle:(NSString *)title
                           andMainImageURL:(NSString *)mainImgURL
                andMediaType:(ShowType)mediaType
                      andFavoriteImageName:(NSString *)favouriteImageName
                              andBindModel:(id)bindModel;

- (NSString *)getCellIdentifier;

- (void)updateView:(PKFavouritesCell *)favouritesCell;

@end
