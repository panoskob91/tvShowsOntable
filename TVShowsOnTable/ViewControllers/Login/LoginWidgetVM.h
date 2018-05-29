//
//  LoginWidgetVM.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKLoginWidgetView.h"

@interface LoginWidgetVM : NSObject

@property (strong, nonatomic) NSString *usernameText;
@property (strong, nonatomic) NSString *passwordText;
@property (strong, nonatomic) NSString *loginAvatarImageURL;
@property (strong, nonatomic) id bindModel;

- (instancetype)initWithUsername:(NSString *)username
                     andPassword:(NSString *)password;

- (void)updateView:(PKLoginWidgetView *)loginView;

@end
