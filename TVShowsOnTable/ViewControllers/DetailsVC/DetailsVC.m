//
//  DetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "DetailsVC.h"
#import "PKDetailsImagesCellVM.h"
#import "PKDetailsTableCellVM.h"
#import "PKNetworkManager.h"

@interface DetailsVC ()
//TO DO: Consider adding this property to Show class
@property (strong, nonatomic) NSString *showSummary;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.show.showTitle;
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchDescriptionFromId:[self.show getShowId] andMediaType:self.show.mediaType];
    
    //[self updateContent];
}

- (void)updateContent
{
    NSMutableArray *sectionForParent = [NSMutableArray new];
    NSMutableArray *titleSection = [NSMutableArray new];
    
    PKDetailsImagesCellVM *newImageVM = [[PKDetailsImagesCellVM alloc] initWithMainImageURLPath:self.show.showBackdropImageURLPath
                                                                                  andShowObject:self.show];
    PKDetailsTableCellVM *detailsTableCellVM = [[PKDetailsTableCellVM alloc] initWithShowSummary:self.showSummary
                                                                                    andBindModel:self.show];
    
    [titleSection addObject:newImageVM];
    [titleSection addObject:detailsTableCellVM];
    
    [sectionForParent addObject:titleSection];
    
    self.sections = [[NSArray alloc] initWithArray:[sectionForParent copy]];
    
    [super updateContent];
}


- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    
}

- (void)APIFetchedWithResponseDescriptionProperty:(NSString *)showSummary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showSummary = [[NSString alloc] init];
        self.showSummary = showSummary;
        [self updateContent];
    });
    //[self updateContent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
