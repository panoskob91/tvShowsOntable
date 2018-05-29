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

- (void)updateView:(PKLoginWidgetView *)loginView
{
    self.usernameText = loginView.usernameTextField.text;
    self.passwordText = loginView.passwordTextField.text;
    [self styleLoginView:loginView];
}

- (void)styleLoginView:(PKLoginWidgetView *)loginView
{
    loginView.layer.cornerRadius = 10;
    loginView.layer.masksToBounds = YES;
    
    loginView.loginWidgetImage.layer.cornerRadius = loginView.loginWidgetImage.frame.size.width / 2;
    loginView.layer.cornerRadius = 10;
    loginView.registerButton.layer.cornerRadius = 5;
    loginView.loginButton.layer.cornerRadius = 5;
}

@end
