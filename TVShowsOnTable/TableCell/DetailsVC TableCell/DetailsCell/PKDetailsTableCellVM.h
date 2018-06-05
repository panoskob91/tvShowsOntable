//
//  PKDetailsVCTableCellVM.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKSummaryCellDetailsVC.h"
#import "PKShowTableCellViewModel.h"
#import "FavoritesHandlingDelegate.h"

//@interface PKDetailsVCTableCellVM : PKShowTableCellViewModel
@interface PKDetailsTableCellVM : NSObject<FavoritesHandlingDelegate>

@property (strong, nonatomic) NSString *showDetailsDescription;
@property (strong, nonatomic) id bindModel;

#pragma mark -Initialisers

- (instancetype)initWithShowSummary:(NSString *)summary
                       andBindModel:(id)bindModel;

- (NSString *)getCellIdentifier;

- (void)updateView:(PKSummaryCellDetailsVC *)detailsCell;

@end
