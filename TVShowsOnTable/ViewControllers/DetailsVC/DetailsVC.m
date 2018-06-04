//
//  DetailsVC.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "DetailsVC.h"
#import "SearchVC.h"
#import "AFSEWebContentHandlerVC.h"

#import "PKDetailsImagesCellVM.h"
#import "PKDetailsTableCellVM.h"
#import "PKNetworkManager.h"

@interface DetailsVC ()

#pragma mark - Class private Properties

//TO DO: Consider moving showSummary property to Show class
@property (strong, nonatomic) NSString *showSummary;
@property (strong, nonatomic) NSString *mainImageURLControlledWithPageControll;

#pragma mark - Outlets

- (IBAction)pageControlHandler:(UIPageControl *)sender;

@end

@implementation DetailsVC

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarWihBackgroundColor:[UIColor lightGrayColor]
                     andNavigationBarTintColor:[UIColor whiteColor]
                             andStatusBarStyle:UIStatusBarStyleLightContent];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setInteger:9001 forKey:@"HighScore"];
//    [defaults synchronize];
    
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    [userDefaults setObject:self.show.showTitle forKey:@"Title"];
    [userDefaults synchronize];
    
    self.mainImageURLControlledWithPageControll = self.show.showBackdropImageURLPath;
    
    self.navigationItem.title = self.show.showTitle;
    PKNetworkManager *networkManager = [[PKNetworkManager alloc] init];
    networkManager.networkingDelegate = self;
    [networkManager fetchDescriptionFromId:[self.show getShowId] andMediaType:self.show.mediaType];
    
    //[self updateContent];
    
    
    //self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - View helper functions

- (void)setupNavigationBarWihBackgroundColor:(UIColor *)backgroundColor
                   andNavigationBarTintColor:(UIColor *)tintColor
                           andStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    self.navigationController.navigationBar.layer.backgroundColor = [backgroundColor CGColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = tintColor;
}

#pragma mark - Star rating system setup

- (NSInteger)roundNumber:(NSNumber *)inputNumber
{
    NSString *stringFromNumber = [NSString stringWithFormat:@"%@", inputNumber];
    NSUInteger dotCharacterIndex = 0;
    NSInteger roundedNumber = inputNumber.integerValue;
    
    //Find dot position
    for (NSUInteger charIndex = 0; charIndex < stringFromNumber.length; charIndex++) {
        unichar currentCharacter = [stringFromNumber characterAtIndex:charIndex];
        
        if (currentCharacter == '.')
        {
            dotCharacterIndex = charIndex;
        }
    }
    if (dotCharacterIndex != 0)
    {
        if ([stringFromNumber characterAtIndex:dotCharacterIndex + 1] >= '5')
        {
            NSNumber *rounded = @(ceil(inputNumber.floatValue));
            roundedNumber = rounded.integerValue;
        }
        else
        {
            NSNumber *rounded = @(floor(inputNumber.floatValue));
            roundedNumber = rounded.integerValue;
        }
    }
    return roundedNumber;
}

- (NSArray<NSString *> *)populateRatingImagesArray
{
    NSMutableArray<NSString *> *rating = [[NSMutableArray alloc] init];
    NSInteger ratingValue = [self roundNumber:self.show.showAverageRating];
    
    for (int i = 0; i < 5; i++)
    {
        if (i < ratingValue / 2)
        {
            [rating addObject:@"filled-star"];
        }
        else
        {
            [rating addObject:@"empty-star"];
        }
    }
    NSArray<NSString *> *starRatings = [[NSArray alloc] initWithArray:rating];
    return starRatings;
    
}

- (void)updateContent
{
    NSMutableArray *sectionForParent = [NSMutableArray new];
    NSMutableArray *titleSection = [NSMutableArray new];
    
    NSArray<NSString *> *ratingImages = [self populateRatingImagesArray];
    
//    PKDetailsImagesCellVM *newImageVM = [[PKDetailsImagesCellVM alloc] initWithMainImageURLPath:self.mainImageURLControlledWithPageControll
//                                                                                  andShowObject:self.show];
    PKDetailsImagesCellVM *newImageVM = [[PKDetailsImagesCellVM alloc] initWithMainImageURLPath:self.mainImageURLControlledWithPageControll
                                                                                  andShowObject:self.show
                                                                        andRatingImageNameArray:ratingImages];
    
    PKDetailsTableCellVM *detailsTableCellVM = [[PKDetailsTableCellVM alloc] initWithShowSummary:self.showSummary
                                                                                    andBindModel:self.show];
    
    [titleSection addObject:newImageVM];
    [titleSection addObject:detailsTableCellVM];
    
    [sectionForParent addObject:titleSection];
    
    self.sections = [[NSArray alloc] initWithArray:[sectionForParent copy]];
    
    [super updateContent];
}

#pragma mark - Network delegete

- (void)networkAPICallDidCompleteWithResponse:(NSArray<Show *> *)shows
{
    
}

- (void)APIFetchedWithResponseDescriptionProperty:(NSString *)showSummary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showSummary = [[NSString alloc] init];
        self.showSummary = showSummary;
        [self updateContent];
    });
    //[self updateContent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView overrides

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKShowTableCellViewModel *cellViewModel = self.sections[indexPath.section][indexPath.row];
    TVShowsCell *cell = (TVShowsCell *)[tableView dequeueReusableCellWithIdentifier:[cellViewModel getCellIdentifier]];
    
    if ([cell isKindOfClass:[PKImagesCellDetailsVC class]])
    {
        AFSEWebContentHandlerVC *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webContentHandler"];
        webViewController.show = self.sections[indexPath.section][indexPath.row].bindModel;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)pageControlHandler:(UIPageControl *)sender
{
    switch (sender.currentPage) {
        case 0:
            self.mainImageURLControlledWithPageControll = self.show.showBackdropImageURLPath;
            break;
        case 1:
            self.mainImageURLControlledWithPageControll = self.show.showImageUrlPath;
            break;
        default:
            break;
    }
    [self updateContent];
}
@end
