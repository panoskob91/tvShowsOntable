//
//  PKDetailsTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKDetailsTableVC.h"
#import "AFSEWebContentHandlerVC.h"
#import "PKDetailsImagesCellVM.h"
#import "PKDetailsTableCellVM.h"

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
    PKDetailsImagesCellVM *imagesCellViewModel = [[PKDetailsImagesCellVM alloc] initWithMainImageURLPath:self.show.showBackdropImageURLPath
                                                                                           andShowObject:self.show];
    PKImagesCellDetailsVC *imagesCell = [tableView dequeueReusableCellWithIdentifier:[imagesCellViewModel getImagesCellIdentifier]];
    
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
    
    PKDetailsImagesCellVM *imagesCellViewModel = [[PKDetailsImagesCellVM alloc] initWithMainImageURLPath:self.show.showBackdropImageURLPath
                                                                                           andShowObject:self.show];
    PKDetailsTableCellVM *detailsCellViewModel = [[PKDetailsTableCellVM alloc] initWithShowSummary:[self getShowSummary]
                                                                                      andBindModel:self.show];
    
    if (indexPath.row == 0)
    {
        PKImagesCellDetailsVC *imagesCell = [tableView dequeueReusableCellWithIdentifier:[imagesCellViewModel getImagesCellIdentifier]];
        [imagesCellViewModel updateImagesCell:imagesCell];
        
        return imagesCell;
    }
    
    
    PKSummaryCellDetailsVC *detailsCell = [tableView dequeueReusableCellWithIdentifier:[detailsCellViewModel getDetailsCellIdentifier]];
    [detailsCellViewModel updateDetailsCell:detailsCell];
    
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
