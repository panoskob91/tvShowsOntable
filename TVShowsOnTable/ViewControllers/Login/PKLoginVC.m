//
//  PKLoginVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKLoginVC.h"
#import "PKLoginWidgetView.h"
#import "SearchVC.h"
#import "LoginWidgetVM.h"


@interface PKLoginVC ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<NSString *> *> *usernamePasswordPair;
@property (strong, nonatomic) NSMutableArray<NSString *> *passwords;
@property (strong, nonatomic) NSMutableArray<NSString *> *usernames;


@end

@implementation PKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add Login widget on screen
    PKLoginWidgetView *loginSubView = [[NSBundle mainBundle] loadNibNamed:@"LoginWidget" owner:self options:nil][0];
    CGFloat loginPageWidth = self.view.frame.size.width;
    CGFloat loginPageHeight = self.view.frame.size.height;
    CGFloat loginSubViewWidth = loginSubView.frame.size.width;
    CGFloat loginSubHeight = loginSubView.frame.size.height;

    loginSubView.frame = CGRectMake(loginPageWidth / 2 - loginSubViewWidth / 2, loginPageHeight / 2 - loginSubHeight / 2, loginSubView.frame.size.width, loginSubView.frame.size.height);
    [self.view addSubview:loginSubView];

    loginSubView.layer.opacity = 0.5;

    LoginWidgetVM *loginVM = [[LoginWidgetVM alloc] initWithUsername:@"Test" andPassword:@"Test"];
    [loginVM updateView:loginSubView];
    
    self.usernamePasswordPair = [[NSMutableDictionary alloc] init];
    self.usernames = [[NSMutableArray alloc] init];
    self.passwords = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUsernameAndPassword:) name:@"Credentials" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToSearchVC) name:@"Match" object:nil];
}

- (void)getUsernameAndPassword:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo;
    [self.passwords addObject:data[@"Password"]];
    [self.usernames addObject:data[@"Username"]];

    [self.usernamePasswordPair setObject:self.usernames forKey:@"username"];
    [self.usernamePasswordPair setObject:self.passwords forKey:@"password"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.usernamePasswordPair[@"username"] forKey:@"username"];
    [defaults setObject:self.usernamePasswordPair[@"password"] forKey:@"password"];
    [defaults synchronize];
    
}

- (void)navigateToSearchVC
{
    SearchVC *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Match" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Credentials" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
