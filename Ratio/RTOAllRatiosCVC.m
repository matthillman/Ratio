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
#import "BouncingViewBehavior.h"
#import "ModalTransitionDelegate.h"
#import "BackButton.h"
#import "RTOSettingsVC.h"
#import "OrderedDictionary.h"
#import "OrderedDictionaryDataSource.h"

@interface RTOAllRatiosCVC () <UICollectionViewDelegate, UINavigationControllerDelegate, RTOSettingsDelegate>
@property (nonatomic, strong) OrderedDictionary *ratios; // of section : NSArray <RTORatio *>
@property (nonatomic, strong) UIView *settings;
@property (nonatomic, strong) UIGestureRecognizer *tgr;
@property (strong, nonatomic) IBOutlet UICollectionView *list;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, strong) BouncingViewBehavior *behavior;
@property (nonatomic, strong) ModalTransitionDelegate *td;
@property (nonatomic, strong) OrderedDictionaryDataSource *ratioDataSource;
@end

@implementation RTOAllRatiosCVC

# pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *next = [self nextViewControllerAtIndexPath:indexPath];
    UICollectionViewCell *selected = [self.collectionView cellForItemAtIndexPath:indexPath];
    if ([selected isKindOfClass:[RTORatioCVC class]] && [next isKindOfClass:[RTORatioVC class]]) {
        RTORatioPieView *pie = ((RTORatioCVC *)selected).ratioPieView;
        RTORatioVC *n = (RTORatioVC *)next;
        n.animationCenter = [pie convertPoint:pie.center toView:nil];
    }
    [self.navigationController pushViewController:next animated:YES];
}

# pragma mark UINavigationControllerDelegate

- (UIViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RTORatioVC *nextVC = (RTORatioVC*)[sb instantiateViewControllerWithIdentifier:@"RatioDisplay"];
    nextVC.ratio = [self ratiosForSection:indexPath.section][indexPath.item];
    nextVC.title = nextVC.ratio.name;
    
    return nextVC;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    RTOAnimatedTransitioning *transitioning = nil;
    if (([toVC isKindOfClass:[RTORatioVC class]] || [fromVC isKindOfClass:[RTORatioVC class]]) && ([toVC isKindOfClass:[RTOAllRatiosCVC class]] || [fromVC isKindOfClass:[RTOAllRatiosCVC class]])) {
        transitioning = [RTOAnimatedTransitioning new];
    }
    
    return transitioning;
}

- (NSString *)keyForSection:(NSInteger)section
{
    return [self.ratios keyAtIndex:section];
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

- (void)settingsTapped
{
    [self.td presentMenu];
}

- (void)defaultsChanged
{
    for (NSArray *section in self.ratios) {
        for (RTORatio *ratio in self.ratios[section]) {
            [ratio resetAmounts];
        }
    }
}

- (void)moveOverlapping:(BOOL)hide
{
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"transform"];
    a.autoreverses = NO;
    a.duration = 0.15f;
    a.fromValue = [NSValue valueWithCATransform3D:self.td.snapshot.layer.transform];
    self.td.snapshot.layer.transform = hide ? CATransform3DMakeTranslation(60, 0, 0) : CATransform3DIdentity;
    a.toValue = [NSValue valueWithCATransform3D:self.td.snapshot.layer.transform];
    a.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.td.snapshot.layer addAnimation:a forKey:nil];
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
    OrderedDictionary *groupedRatios = [[OrderedDictionary alloc] init];
    for (NSDictionary *menu in categoryPlist[@"menus"]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *menuItem in menu[@"itemChildren"]) {
            [list addObject:allRatios[menuItem[@"itemTitle"]]];
        }
        groupedRatios[menu[@"itemTitle"]] = list;
    }
    
    self.ratios = groupedRatios;
    
    self.ratioDataSource = [[OrderedDictionaryDataSource alloc] initWithItems:self.ratios cellIdentifier:@"RatioList" configureCellBlock:^(id cell, id item) {
        if ([cell isKindOfClass:[RTORatioCVC class]]) {
            RTORatioCVC *rcvc = (RTORatioCVC *)cell;
            rcvc.ratioPieView.ratio = item;
            rcvc.ratioTitle.text = rcvc.ratioPieView.ratio.name;
            [rcvc.ratioPieView setNeedsDisplay];
        }
    } headerIdentifier:@"Header" configureHeaderBlock:^(id cell, id item) {
        if ([cell isKindOfClass:[RTORatioListHeadCRV class]]) {
            RTORatioListHeadCRV *hv = (RTORatioListHeadCRV *)cell;
            hv.sectionHeading.text = item;
        }
    }];
    self.list.dataSource = self.ratioDataSource;
    
    UIButton *arrow = [[BackButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    arrow.backgroundColor = [UIColor clearColor];
    [arrow addTarget:self action:@selector(settingsTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithCustomView:arrow];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = btnSettings;
    btnSettings.enabled=TRUE;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RTOSettingsVC *s = [sb instantiateViewControllerWithIdentifier:@"settingstvc"];
    s.delegate = self;
    self.td = [[ModalTransitionDelegate alloc] initWithSender:self.navigationController viewControlerToPresent:s callback:nil];
    
    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.td action:@selector(userDidPan:)];
    gestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
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
