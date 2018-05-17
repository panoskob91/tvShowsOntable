//
//  AFSEShowGroup.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"
#import "AFSEGenreModel.h"

@interface AFSEShowGroup : NSObject

/**
 The genre Id of each section
 */
@property (strong, nonatomic) NSNumber *sectionID;

/**
 An array of Show elements holding the data of each section on this object
 */
@property (strong, nonatomic) NSMutableArray<Show *> *dataInSection;


/**
 Convinient object initialiser

 @param genre_id Genre's id, as returned from the movie db REST API
 @return AFSEShowGroup object initialised
 */
- (instancetype)initWithSectionID: (NSNumber *)genre_id;

@end
