//
//  MyClassTestDelegate.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickShowTypeVC;
@protocol ButtonEventHandlingDelegate<NSObject>

@required
- (void)pickShowTypeVC: (PickShowTypeVC *)pickShowTypeVC
       didSelectButton: (UIButton *)button;


@end
