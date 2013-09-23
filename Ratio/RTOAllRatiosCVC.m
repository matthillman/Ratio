//
//  RTOAllRatiosCVC.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOAllRatiosCVC.h"
#import "RTORatio.h"
#import "RTOIngredient.h"
#import "RTORatioCVC.h"
#import "RTORatioListHeadCRV.h"
#import "RTORatioVC.h"

@interface RTOAllRatiosCVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSDictionary *ratios; // of section : NSArray <RTORatio>
@end

@implementation RTOAllRatiosCVC

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.ratios allKeys] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self ratiosForSection:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RatioList" forIndexPath:indexPath];
    if ([cell isKindOfClass:[RTORatioCVC class]]) {
        RTORatioCVC *rcvc = (RTORatioCVC *)cell;
        rcvc.ratioPieView.ratio = [self ratiosForSection:indexPath.section][indexPath.item];
        rcvc.ratioTitle.text = rcvc.ratioPieView.ratio.name;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *rv = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    if ([rv isKindOfClass:[RTORatioListHeadCRV class]]) {
        RTORatioListHeadCRV *hv = (RTORatioListHeadCRV *)rv;
        hv.sectionHeading.text = [self.ratios keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)][indexPath.section];
    }
    
    return rv;
}

- (NSArray *)ratiosForSection:(NSInteger)section
{
    return self.ratios[[self.ratios keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)][section]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRatio"]) {
        if ([segue.destinationViewController isKindOfClass:[RTORatioVC class]]) {
            RTORatioVC *rvc = (RTORatioVC *)segue.destinationViewController;
            RTORatioCVC *rcvc = (RTORatioCVC *)sender;
            rvc.ratio = rcvc.ratioPieView.ratio;
            rvc.title = rvc.ratio.name;
        }
    }
}

- (void)setup
{
    // load model / read plist
    RTORatio *r = [[RTORatio alloc] init];
    self.ratios = @{@"Doughs": @[r]};
    self.title = @"Ratios";
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (void)viewDidLoad
{
    [self setup];
}

@end
