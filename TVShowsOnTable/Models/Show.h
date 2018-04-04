//
//  Show.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject
{
    NSString *title;
    NSString *image;
    NSString *description;
}
//Setters
- (void)setShowTitle: (NSString*)showTitle;
- (void)setShowImage: (NSString*)showImage;
- (void)setShowDescription: (NSString*)showDescription;
//Getters
- (NSString *)getShowTitle;
- (NSString *)getShowImage;
- (NSString *)getShowDescription;
//Print iinstances
- (void)printInstancevariables;

@end
