//
//  UIColor+rgb.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (rgb)

+ (UIColor *)createColorWithRed: (NSInteger)r
                       andGreen: (NSInteger)g
                        andBlue: (NSInteger)b
                       andAlpha: (CGFloat)a;

@end
