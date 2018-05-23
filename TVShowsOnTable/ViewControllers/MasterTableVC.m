//
//  MasterTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "MasterTableVC.h"
#import "DetailsVC.h"
#import "PKDetailsImagesCellVM.h"


@interface MasterTableVC ()

@end

@implementation MasterTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"detailsVCImagesCell" bundle:nil] forCellReuseIdentifier:@"detailsVCimagesCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"detailsVCDescription" bundle:nil]forCellReuseIdentifier:@"detailsVCDetailsCell"];
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
    //return @"pkompotis";
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
    DetailsVC *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    destController.show = self.sections[indexPath.section][indexPath.row].bindModel;
    destController.hidesBottomBarWhenPushed = YES;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:destController animated:YES];
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
    // Dispose of any resources that can be recreated.
}

@end