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
//@property (strong, nonatomic) id bindModel;

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

/**
 Show Genre ID
 */
@property (strong, nonatomic) NSNumber *showViewModelGenreID;

/**
 Show GenreName
 */
@property (strong, nonatomic) NSString *showViewModelGenreName;

@property (strong, nonatomic) NSMutableArray<PKShowTableCellViewModel *> *showViewModelList;

//- (instancetype)initWIthTitle:(NSString *)title
//                  andImageURL:(NSString *)url
//             andAverageRating:(NSString *)avgRating
//                   andGenreID:(NSNumber *)genreID
//                 andBindModel:(id)bindModel;

- (instancetype)initWithShowViewModelObject:(Show *)showObject;

- (instancetype)initShowViewModelWithGenreID:(NSNumber *)genreID;

- (instancetype)initWithBindModel:(id)bindModel;

- (NSString *)getCellIdentifier;

- (void)updateView:(TVShowsCell *)cell;

//+ (NSArray<NSString *> *)matchIdsWithNamesFromDictionary:(NSDictionary *)dict
//                                        andSourceArray:(NSArray<PKShowTableCellViewModel *> *)sourceArray;
//
//+ (NSArray<PKShowTableCellViewModel *> *)groupItemsBasedOnGenreIdWithDataFromArray:(NSArray<Show *> *)shows;
//
//- (NSString *)getGenreNameBasedOnGenreIdFromDicrionary:(NSDictionary *)dict;
//
//+ (NSArray<PKShowTableCellViewModel *> *)getGroupedArrayFromViewModelsArray:(NSArray<PKShowTableCellViewModel *> *)viewModels
//                                                         andGenreNamesArray:(NSArray<NSString *> *)genreNames;
@end
