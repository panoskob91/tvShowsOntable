//
//  AFSEWebContentHandlerVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 03/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "AFSENetworkingDelegate.h"

@interface AFSEWebContentHandlerVC : UIViewController<AFSENetworkingDelegate>

@property (strong, nonatomic) NSNumber *showIdentifier;
@property (strong, nonatomic) Show *show;

@end
