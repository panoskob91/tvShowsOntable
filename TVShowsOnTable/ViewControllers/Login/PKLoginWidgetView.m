//
//  PKLoginWidgetView.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKLoginWidgetView.h"
#import "SearchVC.h"

@implementation PKLoginWidgetView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.usernamePasswordPairs = [[NSMutableDictionary alloc] init];
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    if ([self.passwordTextField.text isEqualToString:@""] ||
        [self.usernameTextField.text isEqualToString:@""])
    {
        //self.loginButton.backgroundColor = [UIColor redColor];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *defaultsDictionary = [defaults dictionaryRepresentation];
        BOOL uExists = NO;
        BOOL pExists = NO;
        for (NSString *password in defaultsDictionary[@"password"]) {
            if ([self.passwordTextField.text isEqualToString:password])
            {
                pExists = YES;
                break;
            }
        }
        for (NSString *username in defaultsDictionary[@"username"]) {
            if ([self.usernameTextField.text isEqualToString:username])
            {
                uExists = YES;
                break;
            }
        }
        
        if (uExists && pExists)
        {
            NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
            [userData setObject:self.usernameTextField.text forKey:@"username"];
            [userData setObject:self.passwordTextField.text forKey:@"password"];
            NSMutableArray *userFavorites = [[NSMutableArray alloc] init];
            
            //[userFavorites addObject:@"hi"];
            
            NSString *str = @"hi";
            NSData *hiData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSString *hiString = [[NSString alloc] initWithData:hiData encoding:NSWindowsCP1252StringEncoding];
            [userFavorites addObject:hiData];
            NSString *bye = @"bye";
            NSData *byeData = [bye dataUsingEncoding:NSUTF8StringEncoding];
            [userFavorites addObject:byeData];
            //[userFavorites addObject:@"bye"];
            [userData setObject:userFavorites forKey:@"favorites"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Match" object:self];
        }
    }
    
    
}

- (IBAction)registerButtonPressed:(UIButton *)sender
{
    if (![self.usernameTextField.text isEqualToString:@""] &&
        ![self.passwordTextField.text isEqualToString:@""])
    {
        [self.usernamePasswordPairs setObject:self.usernameTextField.text forKey:@"Username"];
        [self.usernamePasswordPairs setObject:self.passwordTextField.text forKey:@"Password"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Credentials" object:self userInfo:self.usernamePasswordPairs];
    }
}

@end
