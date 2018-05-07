//
//  AFSENetworking.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 07/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSENetworkingDelegate.h"

@interface AFSENetworkManager : NSObject

@property (nonatomic, weak) id <AFSENetworkingDelegate> networkingDelegate;
@property (strong, nonatomic) NSMutableArray<Show *> *shows;

-(void)fetchAPICallWithSearchText:(NSString *)searchText;
-(void)fetchDescriptionFromId:(NSNumber *)showId
                  andMediaType:(NSString *)mediaType;

@end
