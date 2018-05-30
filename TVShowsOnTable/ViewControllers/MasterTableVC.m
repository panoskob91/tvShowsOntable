//
//  MasterTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MasterTableVC.h"
#import "DetailsVC.h"
#import "SearchVC.h"
#import "AFSEWebContentHandlerVC.h"

#import "PKDetailsImagesCellVM.h"


@interface MasterTableVC ()

@end

@implementation MasterTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //NSDictionary containing cells. Key:NibName, value:cellID
    NSDictionary<NSString *, NSString *> *cellInfo = @{
                                                       @"ShowsCell" : @"tVShowsCell",
                                                       @"detailsVCImagesCell" : @"detailsVCimagesCell",
                                                       @"detailsVCDescription" : @"detailsVCDetailsCell"
                                                       };
    
    //Add all cells with their identifier
    for (NSString *dictionaryKey in [cellInfo allKeys]) {
        [self.tableView registerNib:[UINib nibWithNibName:dictionaryKey bundle:nil] forCellReuseIdentifier:cellInfo[dictionaryKey]];
    }
}


#pragma mark - TableView Methods
//Set number of Sections in Table View
- (NSInteger)numberOfSectionsInTableView: (UITableView *) tableView
{
    if(self.sections.count == 0)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionNames[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

//Customize table cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKShowTableCellViewModel *cellViewModel = self.sections[indexPath.section][indexPath.row];
    
    TVShowsCell *cell = (TVShowsCell *)[tableView dequeueReusableCellWithIdentifier:[cellViewModel getCellIdentifier]];
    [cellViewModel updateView:cell];
    return cell;
}

//On select table row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isKindOfClass:[SearchVC class]])
    {
        DetailsVC *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
        destController.show = self.sections[indexPath.section][indexPath.row].bindModel;
        destController.hidesBottomBarWhenPushed = YES;

        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        [self.navigationController pushViewController:destController animated:YES];
    }
    else if ([self isKindOfClass:[DetailsVC class]])
    {
        AFSEWebContentHandlerVC *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webContentHandler"];
        webViewController.show = self.sections[indexPath.section][indexPath.row].bindModel;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
}
//Enable editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//Enable row moving
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Move row
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                                                  toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceSection = sourceIndexPath.section;
    NSInteger destinationSection = destinationIndexPath.section;
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destinationRow = destinationIndexPath.row;
    if (sourceSection == destinationSection)
    {
        //This if statment ensures that the rows won't be moved when the row is the same
        if (sourceRow != destinationRow)
        {
            PKShowTableCellViewModel *sourceObject = self.sections[sourceIndexPath.section][sourceIndexPath.row];
            PKShowTableCellViewModel *destinationObject = self.sections[destinationIndexPath.section][destinationIndexPath.row];
            
            //[self.sections[sourceIndexPath.section] removeObject:sourceObject];
            [self.sections[sourceSection] removeObjectAtIndex:sourceRow];
            [self.sections[sourceSection] insertObject:destinationObject atIndex:sourceRow];
            //[self.sections[destinationIndexPath.section] removeObject:destinationObject];
            [self.sections[sourceSection] removeObjectAtIndex:destinationRow];
            [self.sections[sourceSection] insertObject:sourceObject atIndex:destinationRow];
            
            [self.tableView reloadData];
        }
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView reloadData];
    }
}
//Delete row
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                           forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PKShowTableCellViewModel *objectToBeRemoved = self.sections[indexPath.section][indexPath.row];
        [self.sections[indexPath.section] removeObject:objectToBeRemoved];
        //Call reload data, because when update content is called it is also called from subclasses, so it is overrided.
        [self.tableView reloadData];
    }
    
}

//Update the table view elements - reload table view
-(void)updateContent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

@end
