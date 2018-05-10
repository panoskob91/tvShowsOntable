//
//  NSString_stripHtml.h
//  iOSTvMazeApp
//
//  Created by Dimitrios Georgiou on 4/10/18.
//  Copyright © 2018 Dimitrios Georgiou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (stripHtml)

/**
 Function for removing HTML tags on strings

 @return NSString without HTMl tags
 */
- (NSString *)stripHtml;
@end
