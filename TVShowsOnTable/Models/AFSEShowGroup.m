//
//  AFSEShowGroup.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 30/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "AFSEShowGroup.h"

@implementation AFSEShowGroup

- (instancetype)initWithSectionID:(NSNumber *)genre_id
{
    self = [super init];

    if (self)
    {
        self.sectionID = genre_id;
        self.dataInSection = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
