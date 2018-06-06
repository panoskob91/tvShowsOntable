//
//  PKDetailsVCTableCellVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsTableCellVM.h"
#import "Session.h"

@implementation PKDetailsTableCellVM

#pragma mark - Initialisers

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

#pragma mark - Getters

- (NSString *)getCellIdentifier
{
    return @"detailsVCDetailsCell";
}

#pragma mark - Updates

- (void)updateView:(PKSummaryCellDetailsVC *)detailsCell
{
    detailsCell.favouriteHandleDelegate = self;
    detailsCell.detailsCellDescriptionLabel.text = self.showDetailsDescription;
    Show *show = (Show *)self.bindModel;
    if (show.isFavourite)
    {
        [detailsCell.favoritesButton setImage:[UIImage imageNamed:@"filled-star"] forState:UIControlStateNormal];
    }
    else if (!show.isFavourite)
    {
        [detailsCell.favoritesButton setImage:[UIImage imageNamed:@"empty-star"] forState:UIControlStateNormal];
    }
    
    
}

//TODO: Consider working on the behaviour of this view to reflect on the previous one, by working with the following two functions

//- (void)addButtonWasPressedFromCell:(PKSummaryCellDetailsVC *)cell
//{
//    //Add show object to the list array property
//    Session *session = [Session sharedSession];
//    [session.favorite.movies addObject:self.bindModel];
//    Show *show = (Show *)self.bindModel;
//    show.isFavourite = YES;
//    [self updateView:cell];
//}
//
//- (void)removeButtonWasPressedFromCell:(PKSummaryCellDetailsVC *)cell
//{
//    //Remove object from list array
//    Session *session = [Session sharedSession];
//    [session.favorite.movies removeObject:self.bindModel];
//    Show *show = (Show *)self.bindModel;
//    show.isFavourite = NO;
//    [self updateView:cell];
//}

@end
