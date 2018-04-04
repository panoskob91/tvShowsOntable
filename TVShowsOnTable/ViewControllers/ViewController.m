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
    
    
    self.showTitle = [[NSMutableArray alloc] initWithObjects:@"Batman", @"Superman", @"Italian Spiderman", nil];
    self.showImage = [[NSMutableArray alloc] initWithObjects:@"Batman", @"Superman", @"italianSpiderman", nil];
    self.showDescription = [[NSMutableArray alloc] initWithObjects:@"Wealthy entrepreneur Bruce Wayne and his ward Dick Grayson lead a double life: they are actually crime fighting duo Batman and Robin. A secret Batpole in the Wayne mansion leads to the Batcave, where Police Commissioner Gordon often calls with the latest emergency threatening Gotham City. Racing to the scene of the crime in the Batmobile, Batman and Robin must (with the help of their trusty Bat-utility-belt) thwart the efforts of a variety of master criminals, including Catwoman, Egghead, The Joker, King Tut, The Penguin, and The Riddler.",
        @"Superman is a 1988 animated Saturday morning television series produced by Ruby-Spears Productions and Warner Bros. Television that aired on CBS featuring the DC Comics superhero of the same name (coinciding with the character's 50th anniversary, along with the live-action Superboy TV series that year). Veteran comic book writer Marv Wolfman was the head story editor, and noted comic book artist Gil Kane provided character designs.",
        @"Have you ever wondered what would happen if an Italian producer took quaaludes, stumbled into a theater, and saw the first 5 minutes of spider man 2? Well worry no more because Italian Spider-Man is here to haunt your dreams with meteors, snake men, and macchiatos. Let's do it PussyCat!",nil];
    
    
    self.title = @"Shows";
    
    //Initialise shows array
    shows = [[NSMutableArray alloc] init];
    
    //Populate shows array
    for (int i = 0; i < self.showTitle.count; i++) {
        Show *showInfo;
        showInfo = [[Show alloc] init];
        [showInfo setShowTitle: self.showTitle[i]];
        [showInfo setShowImage:self.showImage[i]];
        [showInfo setShowDescription:self.showDescription[i]];
        
        [shows addObject:showInfo];
        
    }
    
//    NSLog(@"New array: %@", shows);
//    for (int i = 0 ; i < 3; i++) {
//        NSLog(@"SHOW TITLE: %@", [shows[i] getShowTitle]);
//        NSLog(@"SHOW IMAGE: %@", [shows[i] getShowImage]);
//        NSLog(@"SHOW DESCRIPTION: %@", [shows[i] getShowDescription]);
//
//    }
    
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

//custom cell height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}


@end
