//
//  Session.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 01/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface Session : NSObject

@property (strong, nonatomic) List *favorite;
+ (id)sharedSession;

@end
