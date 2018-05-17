//
//  UIAlertController+AFSEAlertGenerator.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "UIAlertController+AFSEAlertGenerator.h"

@implementation UIAlertController (AFSEAlertGenerator)

+ (UIAlertController *) generateAlertWithTitle:(NSString *)title
                                    andMessage:(NSString *)msg
                                    andActions:(NSArray<UIAlertAction *> *)alertActions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];

    for (UIAlertAction *alertAction in alertActions)
    {
        [alert addAction:alertAction];
    }
    

    return alert;
}

@end
