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
#import "RTOCalculateVC.h"

@interface RTORatioVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation RTORatioVC
- (IBAction)changeRatioView
{
    CGFloat tx = 0;
    switch (self.viewSelectSegmentedControl.selectedSegmentIndex) {
        case 1:
            tx = -1 * self.ratioCollectionView.bounds.size.width;
            break;
        case 2:
        case 0:
        default:
            tx = 0;
            self.viewSelectSegmentedControl.selectedSegmentIndex = 0;
            break;
    }
    
    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.autoreverses = NO;
    ba.duration = 0.33f;
    ba.fromValue = [NSValue valueWithCATransform3D:self.ratioCollectionView.layer.transform];
    ba.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(tx, 0, 0)];
    [self.ratioCollectionView.layer addAnimation:ba forKey:nil];
    self.ratioCollectionView.layer.transform = CATransform3DMakeTranslation(tx, 0, 0);
    

//    [UIView animateWithDuration:1.5f animations:^{
//        NSLog(@"%f %f", self.ratioCollectionView.bounds.origin.x, self.ratioCollectionView.bounds.origin.y);
//        NSLog(@"%f %f", self.ratioCollectionView.frame.origin.x, self.ratioCollectionView.frame.origin.y);
//        NSLog(@"%f %f", self.ratioCollectionView.transform.tx, self.ratioCollectionView.transform.ty);
//        self.ratioCollectionView.transform = CGAffineTransformMakeTranslation(tx, 0);
//        NSLog(@"%f %f", self.ratioCollectionView.bounds.origin.x, self.ratioCollectionView.bounds.origin.y);
//        NSLog(@"%f %f", self.ratioCollectionView.frame.origin.x, self.ratioCollectionView.frame.origin.y);
//        NSLog(@"%f %f", self.ratioCollectionView.transform.tx, self.ratioCollectionView.transform.ty);
//    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCalculator"]) {
        RTOCalculateVC *cvc = (RTOCalculateVC *)segue.destinationViewController;
        cvc.ratio = self.ratio;
        cvc.viewSelectSegmentedControl.selectedSegmentIndex = self.viewSelectSegmentedControl.selectedSegmentIndex;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewSelectSegmentedControl.selectedSegmentIndex = 0;
}

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
    CGFloat w = self.view.bounds.size.width, h = indexPath.item == 0 ? 220 : 30;
    return CGSizeMake(w, h);
}

@end
