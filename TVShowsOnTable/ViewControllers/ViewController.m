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
    
    //[self parseLocalJSONFileWithName:@"showData"];
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
    //cell.TVShowsImage.image = [UIImage imageNamed:[shows[indexPath.row] getShowImage]]; //Get image on each element and pass it to UIImage constructor
    if ([[shows[indexPath.row] getShowImage] isEqualToString:[NSNull null]] )
    {
        cell.TVShowsImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[shows[indexPath.row] getShowImage]]]];
    }else{
        cell.TVShowsImage.image = [UIImage imageNamed:@"Spiderman"];
    }
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
- (void)parseRemoteJSONWithSearchText: (NSString *)userSearchText
{
    
    [shows removeAllObjects];
    
        userSearchText = [userSearchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userSearchQuery = [NSString stringWithFormat:@"http://api.tvmaze.com/search/shows?q=%@", userSearchText];
        NSURL *searchURL = [NSURL URLWithString:userSearchQuery];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:searchURL];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];

                for (NSDictionary *dict in responseDictionary)
                {
                    
                    Show *showInfo = [[Show alloc] init];
                    NSDictionary *showsReturned = dict[@"show"];
                    //NSLog(@"%@", showsReturned);
                    NSDictionary *image = showsReturned[@"image"];
                    NSString *title = showsReturned[@"name"];
                    NSDictionary *averageRatingDictionary = showsReturned[@"rating"];
                    NSLog(@"%@" , showsReturned[@"summary"]);
                    if (title)
                    {
                        
                        [showInfo setShowTitle:title];
                        
                    }else if (!title){
                        
                        [showInfo setShowTitle:@""];
                        
                    }
                    if (averageRatingDictionary[@"average"] != [NSNull null])
                    {
                        
                        [showInfo setAverageRating:averageRatingDictionary[@"average"]];
                        
                    }else if (averageRatingDictionary[@"average"] == [NSNull null]){
                        
                        [showInfo setAverageRating:(NSNumber *)@""];
                        
                    }
                    if (![showsReturned[@"summary"] isEqualToString:@""])
                    {
                       
                        [showInfo setShowDescription:showsReturned[@"summary"]];
                        
                    }else if ([showsReturned[@"summary"] isEqualToString:@""]){
                        
                        [showInfo setShowDescription:@"No summary available"];
                        
                    }
                    
                    if (image[@"original"])
                    {
                        [showInfo setShowImage:image[@"original"]];
                    }
                    
                    
                    [shows addObject:showInfo];
                                  
                }
                
                
            }
            else{
                NSLog(@"ERROR %@", error);
            }
        }];
        [dataTask resume];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
        });
    });
    
}


@end
