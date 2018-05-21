//
//  PKDetailsTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsTableVC.h"
#import "PKDetailsVCViewModel.h"
#import "AFSEWebContentHandlerVC.h"

@interface PKDetailsTableVC ()

@end

@implementation PKDetailsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCImagesCell" bundle:nil] forCellReuseIdentifier:@"detailsVCimagesCell"];
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"detailsVCDescription" bundle:nil] forCellReuseIdentifier:@"detailsVCDetailsCell"];
    self.detailsTableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Table view functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show
                                                                             andShowSummary:[self getShowSummary]];
    PKImagesCellDetailsVC *imagesCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsImagesCellIdentifier]];
    
    if (indexPath.row == 0)
    {
        imagesCell.backgroundColor = [UIColor greenColor];
        [self performSegueWithIdentifier:@"webViewSegue" sender:self];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKDetailsVCViewModel *detailsVCViewModel = [[PKDetailsVCViewModel alloc] initWithObject:self.show
                                                                             andShowSummary:[self getShowSummary]];
    
    if (indexPath.row == 0)
    {
        PKImagesCellDetailsVC *imagesCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsImagesCellIdentifier]];
        [detailsVCViewModel updateImagesCell:imagesCell];
        
        return imagesCell;
    }
    
    PKSummaryCellDetailsVC *detailsCell = [tableView dequeueReusableCellWithIdentifier:[detailsVCViewModel getDetailsSummaryCellIdentifier]];
    [detailsVCViewModel updateDetailsCell:detailsCell];
    
    return detailsCell;
    
}

#pragma mark -Segue setup
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webViewSegue"])
    {
        AFSEWebContentHandlerVC *webHandlerVC = segue.destinationViewController;
        webHandlerVC.show = self.show;
        webHandlerVC.showIdentifier = [self getTheShowID];
    }
}


@end
