//
//  NSString+url_encoding.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 18/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (url_encoding)

- (NSString *)urlencode:(NSString *)input;

@end
