//
//  MasterTableVC.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKShowTableCellViewModel.h"

@interface MasterTableVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <NSArray <PKShowTableCellViewModel *>*> *sections;
@property (strong, nonatomic) NSArray<NSString *> *sectionNames;

-(void)updateContent;

@end
