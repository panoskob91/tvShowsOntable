//
//  Show.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"

@implementation Show

#pragma mark -Class initialisers

- (instancetype)initWithTitle:(NSString *)ST
                     andImage:(NSString *)SI
               andDescription:(NSString *)SD
             andAverageRating:(NSNumber *)SAR
{
    self = [super init];
    
    if (self)
    {
        
        self.showTitle = ST;
        self.showImage = SI;
        self.showDescription = SD;
        self.showAverageRating = SAR;
        
    }
    
    return self;
    
}


@end
