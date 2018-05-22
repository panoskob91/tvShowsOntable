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

//@interface PKDetailsVCTableCellVM : PKShowTableCellViewModel
@interface PKDetailsTableCellVM : NSObject

@property (strong, nonatomic) NSString *showDetailsDescription;
@property (strong, nonatomic) id bindModel;

#pragma mark -Initialisers
- (instancetype)initWithShowSummary:(NSString *)summary
                       andBindModel:(id)bindModel;

- (NSString *)getDetailsCellIdentifier;

- (void)updateDetailsCell:(PKSummaryCellDetailsVC *)detailsCell;

@end
