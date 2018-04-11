//
//  ViewController.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 02/04/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *showTitle;
@property (strong, nonatomic) NSMutableArray *showDescription;
@property (strong, nonatomic) NSMutableArray *showImage;

@end

@implementation ViewController

    NSMutableArray *shows;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Shows";
    
    //Initialise shows array
    shows = [[NSMutableArray alloc] init];
    [self parseLocalJSONFileWithName:@"showData"];
    [self parseRemoteJSONWithSearchText:_searchedText];
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
    cell.averageRating.text = [NSString stringWithFormat:@"%@", [shows[indexPath.row] getAverageRating]];
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

//custom cell height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

- (void)parseLocalJSONFileWithName:(NSString *)fileName
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSError *error;
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSArray *items = [jsonDictionary valueForKey:@"Shows"];
        
        for (NSDictionary *item in items)
        {
            Show *showInfo = [[Show alloc] init];
            [showInfo setShowTitle:item[@"name"]];
            [showInfo setShowImage:item[@"image"]];
            [showInfo setShowDescription:item[@"description"]];
            NSDictionary *rating = item[@"rating"];
            NSNumber *average = rating[@"average"];
            if (![average isEqual:[NSNull null]])
            {
                [showInfo setAverageRating:average];
            }else{
                [showInfo setAverageRating:(NSNumber *)@""];
            }
            [shows addObject:showInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    });
    
}

- (void)parseRemoteJSONWithSearchText: (NSString *)userText
{
    NSString *userQuery = [userText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"user text %@", userQuery);
    //NSString *user
}


@end
