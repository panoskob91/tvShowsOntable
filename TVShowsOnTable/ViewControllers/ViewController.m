//
//  ViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

    NSMutableArray *shows;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Shows";
    
    //Initialise shows array
    shows = [[NSMutableArray alloc] init];

    [self parseLocalJSONFileWithName:@"showData"];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shows.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVShowsCell"];
    cell.showTitleLabel.text = [shows[indexPath.row] getShowTitle]; //Get the title on each element
    cell.TVShowsImage.image = [UIImage imageNamed:[shows[indexPath.row] getShowImage]]; //Get image on each element and pass it to UIImage constructor
    cell.showsTitleDescription.text = [shows[indexPath.row] getShowDescription]; //Get description on each element
    cell.layer.cornerRadius = 10;
    
        return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    //detailsViewController.detailsViewInfoLabel.text = self.showDescription[indexPath.row];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailsSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *detailsVC = segue.destinationViewController;
        //detailsVC.labelValue = self.showDescription[indexPath.row];
        detailsVC.labelValue = [shows[indexPath.row] getShowDescription];
    }
    
}


//remove bottom lines
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [UIView new];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

//custom cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

- (void)parseLocalJSONFileWithName: (NSString *)fileName
{
    //Get file's path
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    //Convert to JSON object
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    //get the array of values
    NSArray *items = [jsonObject valueForKeyPath:@"Shows"];
    
    for (NSDictionary *item in items)
    {
        Show *showInfo;
        showInfo = [[Show alloc] init];
        [showInfo setShowTitle:[item objectForKey:@"name"]];
        [showInfo setShowImage:[item objectForKey:@"image"]];
        [showInfo setShowDescription:[item objectForKey:@"description"]];

        [shows addObject:showInfo];
    }
    
}
- (void)parseRemoteJSONWithSearchText: (NSString *)userSearchText
{
    userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *userSearchQuery = [NSString stringWithFormat:@"http://api.tvmaze.com/search/shows?q=%@", userSearchText];
    NSLog(@"search Query %@", userSearchQuery);
}

@end
