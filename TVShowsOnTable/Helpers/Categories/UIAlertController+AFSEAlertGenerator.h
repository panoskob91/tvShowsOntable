//
//  UIAlertController+AFSEAlertGenerator.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (AFSEAlertGenerator)

+ (UIAlertController *)generateAlertWithTitle: (NSString *)title
                                   andMessage: (NSString *)msg
                                   andActions: (NSArray<UIAlertAction*> *)alertActions;

@end
