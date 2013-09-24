//
//  RTOAnimatedTransitioning.m
//  Ratio
//
//  Created by Matthew Hillman on 9/23/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOAnimatedTransitioning.h"
#import "RTORatioVC.h"
#import "RTOListCVC.h"

@implementation RTOAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containter = [transitionContext containerView];
    RTORatioVC *rvc = nil;
    if ([toVC isKindOfClass:[RTORatioVC class]]) {
        rvc = (RTORatioVC *)toVC;
    } else {
        rvc = (RTORatioVC *)fromVC;
    }
    
    CGFloat scale = 90.0/220.0;
    UICollectionView *pieCv = rvc.ratioCollectionView;
    CGPoint pieCenter = CGPointMake((pieCv.bounds.origin.x + pieCv.bounds.size.width)/2.0, 152+110);
    CGFloat deltax = rvc.animationCenter.x - pieCenter.x;
    CGFloat deltay = rvc.animationCenter.y - pieCenter.y;
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(deltax, deltay);
    t = CGAffineTransformScale(t, scale, scale);
    
    if ([fromVC isKindOfClass:[RTORatioVC class]]) {
        [containter insertSubview:toVC.view belowSubview:fromVC.view];
    } else {
        rvc.view.transform = t;
        rvc.viewSelectSegmentedControl.alpha = 0;
        rvc.viewSelectSegmentedControl.tintColor = [UIColor colorWithRed:189/255.0 green:44/255.0 blue:11/255.0 alpha:1];
        rvc.view.backgroundColor = [UIColor clearColor];
        
        for (UICollectionViewCell *cell in [rvc.ratioCollectionView visibleCells]) {
            if ([cell isKindOfClass:[RTOListCVC class]]) {
                cell.alpha = 0;
            }
        }
        
        [containter addSubview:toVC.view];
    }
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        if ([fromVC isKindOfClass:[RTORatioVC class]]) {
            rvc.view.transform = t;
            rvc.viewSelectSegmentedControl.alpha = 0;
            rvc.view.backgroundColor = [UIColor clearColor];
            for (UICollectionViewCell *cell in [rvc.ratioCollectionView visibleCells]) {
                if ([cell isKindOfClass:[RTOListCVC class]]) {
                    cell.alpha = 0;
                }
            }
        } else {
            rvc.view.transform = CGAffineTransformIdentity;
            rvc.viewSelectSegmentedControl.alpha = 1;
            rvc.viewSelectSegmentedControl.tintColor = [UIColor colorWithRed:189/255.0 green:44/255.0 blue:11/255.0 alpha:1];
            rvc.view.backgroundColor = [UIColor whiteColor];
            for (UICollectionViewCell *cell in [rvc.ratioCollectionView visibleCells]) {
                if ([cell isKindOfClass:[RTOListCVC class]]) {
                    cell.alpha = 1;
                }
            }
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return (NSTimeInterval)0.25f;
}

@end
