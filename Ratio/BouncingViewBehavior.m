//
//  BouncingViewBehavior.m
//  Ratio
//
//  Created by Matthew Hillman on 10/3/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "BouncingViewBehavior.h"

@interface BouncingViewBehavior ()
@property (nonatomic, strong) id <UIDynamicItem> dynamicView;
@property (nonatomic, strong) UIDynamicItemBehavior *bodyBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;
@end
@implementation BouncingViewBehavior
- (BouncingViewBehavior *)initWithItem:(id <UIDynamicItem>)item anchor:(CGPoint)anchor
{
    if (self=[super init]) {
        self.dynamicView = item;
        self.anchor = anchor;
        
        NSArray *items = @[self.dynamicView];
        
        self.bodyBehavior = [[UIDynamicItemBehavior alloc] init];
        self.bodyBehavior.elasticity = .3;
        [self.bodyBehavior addItem:self.dynamicView];
        
        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -1 * CGRectGetWidth(self.dynamicView.bounds))];
        
        self.attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicView attachedToAnchor:self.anchor];
        self.attachBehavior.damping = .4;
        self.attachBehavior.frequency = 3.0;
        self.attachBehavior.length = .5 * CGRectGetWidth(self.dynamicView.bounds);
        
        [self addChildBehavior:self.collisionBehavior];
        [self addChildBehavior:self.bodyBehavior];
        [self addChildBehavior:self.attachBehavior];

    }
    
    return self;
}
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    self.transitionContext = transitionContext;
//    self.da.delegate = self;
//    UIView *inView = [transitionContext containerView];
//    CGFloat width = inView.frame.size.width;
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    if (self.isAppearing) {
//        self.dynamicView = [fromVC.view resizableSnapshotViewFromRect:fromVC.view.bounds afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.dynamicView.bounds];
//        self.dynamicView.layer.masksToBounds = NO;
//        self.dynamicView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.dynamicView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//        self.dynamicView.layer.shadowOpacity = 0.5f;
//        self.dynamicView.layer.shadowPath = shadowPath.CGPath;
//
//        if (self.delegate) {
//            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(completeModal)];
//            [self.dynamicView addGestureRecognizer:tgr];
//        }
//        
//        self.toView = toVC.view;
//
//        [fromVC.view insertSubview:toVC.view aboveSubview:fromVC.view];
//        [fromVC.view addSubview:self.dynamicView];
//    }
//    NSArray *items = @[self.dynamicView];
//    
//    self.bodyBehavior = [[UIDynamicItemBehavior alloc] init];
//    self.bodyBehavior.elasticity = .3;
//    [self.bodyBehavior addItem:self.dynamicView];
//    
//    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
//    [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -1 * width)];
//    
//    CGPoint anchor = (self.isAppearing) ? CGPointMake((2 * width) - 50, self.dynamicView.center.y) : CGPointMake(0, self.dynamicView.center.y);
//
//    self.attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicView attachedToAnchor:anchor];
//    self.attachBehavior.damping = .4;
//    self.attachBehavior.frequency = 3.0;
//    self.attachBehavior.length = .5 * width;
//    
//    self.finishTime = [self.da elapsedTime] + duration;
//    BouncingViewBehavior *weakSelf = self;
//    
//    self.action = ^{
//        if([weakSelf.da elapsedTime] >= weakSelf.finishTime) {
//            [weakSelf.da removeBehavior:weakSelf];
//            if (!weakSelf.isAppearing) {
//                [weakSelf removeAllChildBehaviors];
//                [weakSelf cleanUpAnimation];
//            }
//        }
//    };
//    
//    [self addChildBehavior:self.collisionBehavior];
//    [self addChildBehavior:self.bodyBehavior];
//    [self addChildBehavior:self.attachBehavior];
//    [self.da addBehavior:self];
//}

- (void) removeAllChildBehaviors
{
    [self removeChildBehavior:self.collisionBehavior];
    self.collisionBehavior = nil;
    [self removeChildBehavior:self.bodyBehavior];
    self.bodyBehavior = nil;
    [self removeChildBehavior:self.attachBehavior];
    self.attachBehavior = nil;
}

- (void)cleanUpAnimation
{
//    [self.dynamicView removeFromSuperview];
    [self removeAllChildBehaviors];
    self.dynamicView = nil;
//    [self.toView removeFromSuperview];
//    self.toView = nil;
}

//- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
//{
//    if ([animator elapsedTime] > self.finishTime) {
//        [self.transitionContext completeTransition: YES];
//        [self removeAllChildBehaviors];
//        [self.da removeAllBehaviors];
//        self.transitionContext = nil;
//        if (!self.isAppearing) [self cleanUpAnimation];
//    }
//}
//
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    return self.isAppearing ? 0.75f : 0.5f;
//}

- (void)setAnchor:(CGPoint)anchor
{
    _anchor = anchor;
    [self.attachBehavior setAnchorPoint:_anchor];
}
@end
