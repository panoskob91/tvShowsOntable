//
//  DetailsVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocols, Delegates
#import "PKFavouriteHandleDelegate.h"

#import "AFSENetworkingDelegate.h"
//ViewCotrollers

//Mater ViewController
#import "MasterTableVC.h"
//#import "Show.h"

@interface DetailsVC : MasterTableVC <AFSENetworkingDelegate>

@property (strong, nonatomic) Show *show;

@end
