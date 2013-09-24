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
#import "RTOAnimatedTransitioning.h"

@interface RTOAllRatiosCVC () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSDictionary *ratios; // of section : NSArray <RTORatio *>
@property (nonatomic, strong) NSArray *orderedSections; // of NSString *
@end

@implementation RTOAllRatiosCVC

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *next = [self nextViewControllerAtIndexPath:indexPath];
    UICollectionViewCell *selected = [self.collectionView cellForItemAtIndexPath:indexPath];
    if ([selected isKindOfClass:[RTORatioCVC class]] && [next isKindOfClass:[RTORatioVC class]]) {
        RTORatioPieView *pie = ((RTORatioCVC *)selected).ratioPieView;
        RTORatioVC *n = (RTORatioVC *)next;
        CGPoint pieCenter = CGPointMake((pie.bounds.origin.x + pie.bounds.size.width)/2.0, (pie.bounds.origin.y + pie.bounds.size.height)/2.0);
        n.animationCenter = [pie convertPoint:pieCenter toView:nil];
    }
    [self.navigationController pushViewController:next animated:YES];
}

- (UIViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RTORatioVC *nextVC = (RTORatioVC*)[sb instantiateViewControllerWithIdentifier:@"RatioDisplay"];
    nextVC.ratio = [self ratiosForSection:indexPath.section][indexPath.item];
    nextVC.title = nextVC.ratio.name;
    
    return nextVC;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    RTOAnimatedTransitioning *transitioning = nil;
    if ([toVC isKindOfClass:[RTORatioVC class]]) {
        transitioning = [RTOAnimatedTransitioning new];
        if (operation == UINavigationControllerOperationPop) {
            transitioning.reverse = YES;
        }
    }
    return transitioning;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.orderedSections count];
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
        [rcvc.ratioPieView setNeedsDisplay];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *rv = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    if ([rv isKindOfClass:[RTORatioListHeadCRV class]]) {
        RTORatioListHeadCRV *hv = (RTORatioListHeadCRV *)rv;
        hv.sectionHeading.text = [self keyForSection:indexPath.section];
    }
    
    return rv;
}

- (NSString *)keyForSection:(NSInteger)section
{
    return self.orderedSections[section];
}

- (NSArray *)ratiosForSection:(NSInteger)section
{
    return self.ratios[[self keyForSection:section]];
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
    self.navigationController.delegate = self;
    
    self.title = @"Ratios";
    
    NSString *ratioPath = [[NSBundle mainBundle] pathForResource:@"ratios" ofType:@"plist"];
    NSMutableDictionary *ratioPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:ratioPath];
    NSMutableDictionary *allRatios = [[NSMutableDictionary alloc] init];
    for (NSDictionary *ratio in ratioPlist[@"ratios"]) {
        RTORatio *r = [[RTORatio alloc] initWithRatioDict:ratio];
        allRatios[r.name] = r;
    }
    
    NSString *menuPath = [[NSBundle mainBundle] pathForResource:@"menus" ofType:@"plist"];
    NSMutableDictionary *categoryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:menuPath];
    NSMutableDictionary *groupedRatios = [[NSMutableDictionary alloc] init];
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for (NSDictionary *menu in categoryPlist[@"menus"]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *menuItem in menu[@"itemChildren"]) {
            [list addObject:allRatios[menuItem[@"itemTitle"]]];
        }
        groupedRatios[menu[@"itemTitle"]] = list;
        [sections addObject:menu[@"itemTitle"]];
    }
    
    self.ratios = groupedRatios;
    self.orderedSections = sections;
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
