//
//  RTORatioVC.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTORatioVC.h"
#import "RTORatioCVC.h"
#import "RTOListCVC.h"

@interface RTORatioVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation RTORatioVC

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.ratio.ingredients count] + 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.ratioCollectionView dequeueReusableCellWithReuseIdentifier:indexPath.item == 0 ? @"Ratio" : @"List" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RTORatioCVC class]]) {
        RTORatioCVC *rcvc = (RTORatioCVC *)cell;
        rcvc.ratioPieView.ratio = self.ratio;
    } else if ([cell isKindOfClass:[RTOListCVC class]]) {
        RTOListCVC *lcvc = (RTOListCVC *)cell;
        lcvc.ratioPieView.ratio = self.ratio;
        lcvc.ratioPieView.indexPath = indexPath;
        lcvc.ingredientLabel.text = [((RTOIngredient *)self.ratio.ingredients[indexPath.item-1]) description];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, indexPath.item == 0 ? 220 : 30);
}

@end
