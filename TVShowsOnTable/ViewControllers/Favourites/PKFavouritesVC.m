//
//  PKFavouritesVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 05/06/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKFavouritesVC.h"
#import "Session.h"
#import "PKFavouritesCellVM.h"

@interface PKFavouritesVC ()

@end

@implementation PKFavouritesVC

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self updateContent];
    
}

- (void)updateContent
{
    Session *session = [Session sharedSession];
    NSArray<Show *> *shows = session.favorite.movies;
    
    NSMutableArray *sectionForParent = [NSMutableArray new];
    NSMutableArray *titleSection = [NSMutableArray new];
    
    for (Show *show  in shows) {
        PKFavouritesCellVM *favoritesVM = [[PKFavouritesCellVM alloc] initWithFavouriteShowTitle:show.showTitle
                                                                                 andMainImageURL:show.showImageUrlPath
                                                                                    andMediaType:show.mediaType
                                                                            andFavoriteImageName:@"filled-star"
                                                                                    andBindModel:show];
        [titleSection addObject:favoritesVM];
    }
    
    
    
    [sectionForParent addObject:titleSection];
    
    self.sections = [[NSArray alloc] initWithArray:[sectionForParent copy]];
    
    [super updateContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
