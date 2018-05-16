//
//  PKShowTableCellViewModel.m
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 14/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "PKShowTableCellViewModel.h"

@implementation PKShowTableCellViewModel

#pragma mark -Initialisers
- (instancetype)initWIthTitle:(NSString *)title
                  andImageURL:(NSString *)url
             andAverageRating:(NSString *)avgRating
                   andGenreID:(NSNumber *)genreID
                 andBindModel:(id)bindModel
{
    self = [super init];
    
    if (self)
    {
        self.showViewModelTitle = title;
        self.showViewModelImageURL = url;
        self.showViewModelAverageRating = avgRating;
        self.showViewModelGenreID = genreID;
        self.bindModel = (Show *)bindModel;
        
    }
    return self;
}

- (instancetype)initShowViewModelWithGenreID:(NSNumber *)genreID
{
    self = [super init];
    if (self)
    {
        self.showViewModelGenreID = genreID;
        self.showViewModelList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithShowViewModelObject:(Show *)showObject
{
    NSString *averageRating = [NSString stringWithFormat:@"%@/10", showObject.showAverageRating];
    self = [self initWIthTitle:showObject.showTitle
                   andImageURL:showObject.showImageUrlPath
              andAverageRating:averageRating
                    andGenreID:showObject.showGenreID
                  andBindModel:showObject];
    
    if (self)
    {
        self.showViewModelList = [[NSMutableArray alloc] init];
        self.showViewModelGenreName = [[NSString alloc] init];
    }
    return self;
}

- (instancetype)initWithBindModel:(id)bindModel
{
    self = [super init];
    if (self)
    {
        self.bindModel = (Show *)bindModel;
    }
    return self;
}

#pragma mark -Class Methods
- (NSString *)getCellIdentifier
{
 return @"tVShowsCell";
}

- (void)updateView:(TVShowsCell *)cell
{
    cell.showTitleLabel.text = self.showViewModelTitle;
    
        NSURL *imageURL = [NSURL URLWithString:self.showViewModelImageURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    cell.tvShowsImage.image = [UIImage imageWithData:imageData];
    if (![self.showViewModelAverageRating isEqualToString:@""])
    {
        cell.showAverageRatingLabel.text = self.showViewModelAverageRating;
    }
    else
    {
        cell.showAverageRatingLabel.text = @"";
    }
    
    if ([self.bindModel.mediaType isEqualToString:@"tv"])
    //if (self.bindModel.mediaType == ShowTypeTVSeries)
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"TvSeries"];
    }
    else if ([self.bindModel.mediaType isEqualToString:@"movie"])
    //else if (self.bindModel.mediaType == ShowTypeMovie)
    {
        cell.showTypeImageView.image = [UIImage imageNamed:@"movieImage"];
    }
    
}

+ (NSArray<NSString *> *)matchIdsWithNamesFromDictionary:(NSDictionary *)dict
                                          andSourceArray:(NSArray<PKShowTableCellViewModel *> *)sourceArray
{
    NSMutableArray *titleNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < sourceArray.count; i++)
    {
        for (NSString *key in [dict allKeys])
        {
            NSNumber *keyNumber = @([key intValue]);
            if ([sourceArray[i].showViewModelGenreID isEqual:keyNumber])
            {
                [titleNames addObject:dict[key]];
            }
        }
    }
    for (int i = 0; i < titleNames.count - 1; i++)
    {
        if (titleNames[i] == titleNames[i + 1])
        {
            [titleNames removeObject:titleNames[i]];
        }
    }
    NSArray *genreTitles = [[NSArray alloc] initWithArray:titleNames];
    return genreTitles;
}

+ (NSArray<PKShowTableCellViewModel *> *)groupItemsBasedOnGenreIdWithDataFromArray:(NSArray<Show *> *)shows
{
    NSMutableArray<PKShowTableCellViewModel *> *groupedArray = [[NSMutableArray alloc] init];
    BOOL onList = NO;
    
    for (Show *show in shows)
    {
        PKShowTableCellViewModel *showGroupViewModel = [[PKShowTableCellViewModel alloc] initWithShowViewModelObject:show];
        for (int i = 0; i < groupedArray.count; i++)
        {
            if ([show.showGenreID isEqual:groupedArray[i].showViewModelGenreID])
            {
                [groupedArray addObject:showGroupViewModel];
                onList = YES;
                break;
            }
            
        }
        if(onList == NO)
        {
            
            [groupedArray addObject:showGroupViewModel];
        }
        onList = NO;
        
    }
    return groupedArray;
}

- (NSString *)getGenreNameBasedOnGenreIdFromDicrionary:(NSDictionary *)dict

{
    NSString *outputString = [[NSString alloc] init];
    
    for (NSString *key in [dict allKeys])
    {
        NSNumber *keyNumber = @([key intValue]);
        if ([self.showViewModelGenreID isEqual:keyNumber])
        {
            outputString = dict[key];
            break;
        }
    }
    return outputString;
}

+ (NSArray<PKShowTableCellViewModel *> *)getGroupedArrayFromViewModelsArray:(NSArray<PKShowTableCellViewModel *> *)viewModels
                                                         andGenreNamesArray:(NSArray<NSString *> *)genreNames
{
    NSMutableArray<PKShowTableCellViewModel *> *viewModelGroupedGenreArray = [[NSMutableArray alloc] init];
    for (NSString *genreName in genreNames)
    {
        for (PKShowTableCellViewModel *viewModel in viewModels)
        {
            if ([viewModel.showViewModelGenreName isEqual:genreName])
            {
                [viewModelGroupedGenreArray addObject:viewModel];
            }
        }
    }
    return viewModelGroupedGenreArray;
    
}

@end
