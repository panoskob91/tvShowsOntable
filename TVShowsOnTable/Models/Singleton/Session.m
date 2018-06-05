//
//  Session.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 01/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Session.h"

@implementation Session

+ (id)sharedSession
{
    static Session *session = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[self alloc] init];
    });
    
    return session;
}

- (id)init {
    if (self = [super init]) {
        self.favorite = [[List alloc] initWithName:@"favorite"];
    }
    return self;
}


@end
