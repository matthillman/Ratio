//
//  OrderedDictionaryDataSource.m
//  Ratio
//
//  Created by Matthew Hillman on 11/12/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "OrderedDictionaryDataSource.h"

@interface OrderedDictionaryDataSource ()

@property (nonatomic, strong) OrderedDictionary *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CellConfigureBlock configureCellBlock;
@property (nonatomic, copy) NSString *headerIdentifier;
@property (nonatomic, copy) CellConfigureBlock configureHeaderBlock;

@end

@implementation OrderedDictionaryDataSource

# pragma mark Init

- (id)init
{
    return nil;
}

- (id)initWithItems:(OrderedDictionary *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

-  (id)initWithItems:(OrderedDictionary *)anItems
      cellIdentifier:(NSString *)aCellIdentifier
  configureCellBlock:(CellConfigureBlock)aConfigureCellBlock
    headerIdentifier:(NSString *)aHeaderIdentifier
configureHeaderBlock:(CellConfigureBlock)aConfigureHeaderBlock
{
    self = [self initWithItems:anItems cellIdentifier:aCellIdentifier configureCellBlock:aConfigureCellBlock];
    if (self) {
        self.headerIdentifier = aHeaderIdentifier;
        self.configureHeaderBlock = aConfigureHeaderBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[[self.items keyAtIndex:indexPath.section]][indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return [self.items keyAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self.items objectAtIndex:section] count];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *rv = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.headerIdentifier forIndexPath:indexPath];
    id item = [self.items keyAtIndex:indexPath.section];
    self.configureHeaderBlock(rv, item);
    return rv;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
