//
//  PKLoginVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 24/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKLoginVC.h"
#import "PKLoginWidgetView.h"

@interface PKLoginVC ()

@end

@implementation PKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add Login widget on screen
    PKLoginWidgetView *loginSubView = [[NSBundle mainBundle] loadNibNamed:@"LoginWidget" owner:self options:nil][0];
    NSLog(@"%@", loginSubView);
    CGFloat loginPageWidth = self.view.frame.size.width;
    CGFloat loginPageHeight = self.view.frame.size.height;
    CGFloat loginSubViewWidth = loginSubView.frame.size.width;
    CGFloat loginSubHeight = loginSubView.frame.size.height;
    
    loginSubView.frame = CGRectMake(loginPageWidth / 2 - loginSubViewWidth / 2, loginPageHeight / 2 - loginSubHeight / 2, loginSubView.frame.size.width, loginSubView.frame.size.height);
    [self.view addSubview:loginSubView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
