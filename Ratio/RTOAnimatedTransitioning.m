//
//  RTOAnimatedTransitioning.m
//  Ratio
//
//  Created by Matthew Hillman on 9/23/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOAnimatedTransitioning.h"

@implementation RTOAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containter = [transitionContext containerView];
    
    if (self.reverse) {
        [containter insertSubview:toVC.view belowSubview:fromVC.view];
    } else {
        toVC.view.transform = CGAffineTransformMakeScale(.5, .5);
        [containter addSubview:toVC.view];
    }
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        if (self.reverse) {
            fromVC.view.transform = CGAffineTransformMakeScale(0, 0);
        } else {
            toVC.view.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return (NSTimeInterval)1.5f;
}

@end
