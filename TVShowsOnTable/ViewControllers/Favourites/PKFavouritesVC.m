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
#import "UIAlertController+AFSEAlertGenerator.h"

@interface PKFavouritesVC ()

@end

@implementation PKFavouritesVC

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self alertWhenNoFavoritesAreStored];
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

- (void)alertWhenNoFavoritesAreStored
{

    if (self.sections.count == 0)
    {
        NSString *alertMessage = @"There are no favorites stored yet";
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [actionOK setValue:[UIColor blueColor] forKey:@"titleTextColor"];
        
        NSMutableArray<UIAlertAction*> *alertActions = [[NSMutableArray alloc] init];
        [alertActions addObject:actionOK];
        
        UIAlertController *alert = [UIAlertController generateAlertWithTitle:@"Alert!" andMessage:alertMessage andActions:alertActions];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

@end
