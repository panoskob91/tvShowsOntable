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

//@property (strong, nonatomic) AFSEGenreModel *sectionTitle;
@property (strong, nonatomic) NSNumber *sectionID;
@property (strong, nonatomic) NSMutableArray<Show *> *dataInSection;


-(instancetype) initWithSectionID: (NSNumber *) genre_id;

//-(instancetype) initWithSectionId: (NSNumber *) ID
//                    andElement: (Show *)showObject;

@end
