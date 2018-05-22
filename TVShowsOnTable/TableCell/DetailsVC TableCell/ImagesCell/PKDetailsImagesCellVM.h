//
//  PKDetailsImagesCellVM.h
//  TVShowsOnTable
//
//  Created by Panagiotis Kompotis on 22/05/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"
#import "PKImagesCellDetailsVC.h"

@interface PKDetailsImagesCellVM : NSObject

@property (strong, nonatomic) NSString *mainImageUrlPath;
@property (strong, nonatomic) NSString *mediaTypeIndicatorImageName;

/**
 Images cell initialiser

 @param mainImageURL The URL of the main image inside the cell
 @param showObject A show object used to get media type image indicator name from mediaType property
 @return DetailsImagesCellViewModel object
 */
- (instancetype)initWithMainImageURLPath:(NSString *)mainImageURL
                           andShowObject:(Show *)showObject;


/**
 Update cell with data from VM

 @param imagesCell Cell connected with PKImageseCellDetailsVC
 */
- (void)updateImagesCell:(PKImagesCellDetailsVC *)imagesCell;

- (NSString *)getImagesCellIdentifier;

@end
