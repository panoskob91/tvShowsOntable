//
//  UIColor+rgb.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (rgb)

/**
 UIColor category. A class method is defined with which, it is not needed to divide each argument by 255 in order to generate UIColor

 @param r Red
 @param g Green
 @param b Blue
 @param a Alpha
 @return UIColor
 */
+ (UIColor *)createColorWithRed: (NSInteger)r
                       andGreen: (NSInteger)g
                        andBlue: (NSInteger)b
                       andAlpha: (CGFloat)a;

@end
