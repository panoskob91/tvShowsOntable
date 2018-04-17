//
//  Show.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

#pragma mark -Class Properties

@property (strong, nonatomic) NSString *showTitle;
@property (strong, nonatomic) NSString *showImage;
@property (strong, nonatomic) NSNumber *showAverageRating;


#pragma mark -Initialisers

- (instancetype)initWithTitle: (NSString *)ST
                     andImage: (NSString *)SI
             andAverageRating: (NSNumber *)SAR;

@end
