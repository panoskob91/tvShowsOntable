//
//  PKDetailsVCTableCellVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsTableCellVM.h"

@implementation PKDetailsTableCellVM

#pragma mark -Initialisers
- (instancetype)initWithShowSummary:(NSString *)summary
                       andBindModel:(id)bindModel
{
    self = [super init];
    
    if (self)
    {
        self.showDetailsDescription = summary;
        self.bindModel = bindModel;
    }
    return self;
}


- (NSString *)getDetailsCellIdentifier
{
    return @"detailsVCDetailsCell";
}

- (void)updateDetailsCell:(PKSummaryCellDetailsVC *)detailsCell
{
    detailsCell.detailsCellDescriptionLabel.text = self.showDetailsDescription;
}

@end
