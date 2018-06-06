//
//  PKIndexingProtocol.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 06/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVShowsCell.h"

@protocol PKIndexingProtocol <NSObject>

@optional
//- (NSIndexPath *)tableViewCell:(TVShowsCell *)cell WasPressedAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableViewWasPressedAtIndexPath:(NSIndexPath *)indexPath;

@end
