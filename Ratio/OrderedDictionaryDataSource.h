//
//  OrderedDictionaryDataSource.h
//  Ratio
//
//  Created by Matthew Hillman on 11/12/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

typedef void (^CellConfigureBlock)(id cell, id item);

@interface OrderedDictionaryDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithItems:(OrderedDictionary *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CellConfigureBlock)aConfigureCellBlock;

-  (id)initWithItems:(OrderedDictionary *)anItems
      cellIdentifier:(NSString *)aCellIdentifier
  configureCellBlock:(CellConfigureBlock)aConfigureCellBlock
    headerIdentifier:(NSString *)aHeaderIdentifier
configureHeaderBlock:(CellConfigureBlock)aConfigureHeaderBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
