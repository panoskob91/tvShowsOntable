//
//  Show.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "Show.h"

@implementation Show

- (void)setShowTitle: (NSString*)showTitle
{
    title = showTitle;
}

- (void)setShowImage:(NSString *)showImage
{
    image = showImage;
}

- (void)setShowDescription:(NSString *)showDescription
{
    description = showDescription;
}

- (void)setAverageRating:(NSNumber*)rating
{
    averageRating = rating;
}

- (void)printInstancevariables
{
    NSLog(@"\ntitle: %@,\nimage: %@,\ndescription: %@\n", title, image, description);
}

- (NSString *)getShowTitle
{
    return title;
}

- (NSString *)getShowImage
{
    return image;
}

- (NSString *)getShowDescription
{
    return description;
}

- (NSNumber *)getAverageRating
{
    return averageRating;
}

@end
