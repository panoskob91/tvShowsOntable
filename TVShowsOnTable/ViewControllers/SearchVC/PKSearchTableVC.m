//
//  PKSearchTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

//View controllers
#import "PKSearchTableVC.h"
#import "DetailsViewController.h"
#import "PKDetailsTableVC.h"
//View models
#import "PKShowTableCellViewModel.h"
//categories
#import "UIAlertController+AFSEAlertGenerator.h"

@interface PKSearchTableVC ()


@end

@implementation PKSearchTableVC

NSArray *showsSelectedCells;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
    
    //[self updateContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -TableView functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    showsSelectedCells = [self.tableView indexPathsForSelectedRows];

    //DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    PKDetailsTableVC *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    
    Show *show = self.sections[indexPath.section][indexPath.row].bindModel;
    NSNumber *showID = [[NSNumber alloc] init];
    NSString *showTitleFromGroups = show.showTitle;
        detailsVC.navigationItemTitle = showTitleFromGroups;
    NSString *imageURLFromGroups = show.showImageUrlPath;
        detailsVC.imageURL = imageURLFromGroups;
    NSNumber *showIdFromGroups = [show getShowId];
    showID = showIdFromGroups;

    detailsVC.show = show;
    [detailsVC setTheShowID:showID];
    [self.navigationController pushViewController:detailsVC animated:YES];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UITableViewCellEditingStyleDelete)
    {
        NSMutableArray<PKShowTableCellViewModel *> *showsArray = [self.sections[indexPath.section] mutableCopy];
        [showsArray removeObjectAtIndex:indexPath.row];
    }
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PKShowTableCellViewModel *objectToBeMoved = self.sections[sourceIndexPath.section][sourceIndexPath.row];
            NSMutableArray<PKShowTableCellViewModel *> *showsInSection = self.sections[sourceIndexPath.section];
            [showsInSection removeObjectAtIndex:sourceIndexPath.row];
            [showsInSection insertObject:objectToBeMoved atIndex:destinationIndexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
    }
    else
    {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView reloadData];
        }];
        NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
        [alertActions addObject:actionOK];

        //NSArray *genreNames = [self matchIdsWithNamesFromDictionary:self.showGenresDictionary andSourceArray:self.showGroupsArray];
//        NSString *alertMessage = [NSString stringWithFormat:@"Sorry, you cannot move elements from section %@ to section %@",
//                                  genreNames[sourceIndexPath.section], genreNames[destinationIndexPath.section]];

        NSString *alertMessage = @"Sorry, you cannot move elements between sections";
        
        UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Attention!" andMessage:alertMessage andActions:alertActions];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sections[section].count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [NSString stringWithFormat:@"%@", self.sections[section]];
    return self.genreNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKShowTableCellViewModel *showViewModel = self.sections[indexPath.section][indexPath.row];
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:[showViewModel getCellIdentifier]];
    [showViewModel updateView:cell];
    
    return cell;
}

@end
