//
//  LoginWidgetVM.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "LoginWidgetVM.h"

@implementation LoginWidgetVM

- (instancetype)initWithUsername:(NSString *)username
                     andPassword:(NSString *)password
{
    self = [super init];
    if (self)
    {
        self.usernameText = username;
        self.passwordText = password;
    }
    return self;
}

- (void)setupView:(PKLoginWidgetView *)loginView
{
    self.usernameText = loginView.usernameTextField.text;
    self.passwordText = loginView.passwordTextField.text;
}

@end
