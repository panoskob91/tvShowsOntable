//
//  AFSENetworkingDelegate.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 07/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"

@protocol AFSENetworkingDelegate <NSObject>

- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows;
@optional
- (void)APIFetchedWithResponseDescriptionProperty:(NSString *)showSummary;
- (void)networkCallDidCompleteAndYoutubeKeyGenerated:(NSString *)youtubeKey;

@end
