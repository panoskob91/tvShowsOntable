//
//  UIColor+rgb.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "UIColor+rgb.h"

@implementation UIColor (rgb)

+ (UIColor *)createColorWithRed:(NSInteger)r
                       andGreen: (NSInteger)g
                        andBlue: (NSInteger)b
                       andAlpha: (CGFloat)a
{
    CGFloat red =  r / 255;
    CGFloat green = g / 255;
    CGFloat blue = b / 255;
    
    return [UIColor colorWithRed: red green: green blue: blue alpha:a];
}

@end
