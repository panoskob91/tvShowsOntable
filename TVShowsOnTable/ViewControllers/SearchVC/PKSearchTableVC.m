//
//  PKSearchTableVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 17/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKSearchTableVC.h"
#import "PKShowTableCellViewModel.h"

@interface PKSearchTableVC ()

@property (strong, nonatomic) NSArray <NSArray <PKShowTableCellViewModel *> *> *sectionsArray;

@end

@implementation PKSearchTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowsCell" bundle:nil] forCellReuseIdentifier:@"tVShowsCell"];
    
//    [super updateContent];
    self.sectionsArray = [self getSectionsArray];
    NSLog(@"sections = %@", self.sectionsArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKShowTableCellViewModel *showViewModel = self.sectionsArray[indexPath.section][indexPath.row];
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:[showViewModel getCellIdentifier]];
    return cell;
}

@end
