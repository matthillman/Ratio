//
//  ModalTransitionDelegate.m
//  Ratio
//
//  Created by Matthew Hillman on 10/3/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "ModalTransitionDelegate.h"
#import "BouncingViewBehavior.h"

@interface ModalTransitionDelegate () <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIDynamicAnimatorDelegate>
@property (nonatomic, weak) UIViewController *sender;
@property (nonatomic, copy) void (^callback)(void);

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, assign, getter = isCompleting) BOOL completing;
@property (nonatomic, assign, getter = isInteractiveTransitionInteracting) BOOL interactiveTransitionInteracting;
@property (nonatomic, assign, getter = isInteractiveTransitionUnderway) BOOL interactiveTransitionUnderway;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UITapGestureRecognizer *dismissTap;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) BouncingViewBehavior *b;
@property (nonatomic, strong) UIAttachmentBehavior *ab;
@property (nonatomic, assign) CGPoint lastKnownVelocity;

@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, strong) UIView *main;
@property (nonatomic, strong) UIView *interactiveSettings;

@end

@implementation ModalTransitionDelegate
- (instancetype)initWithSender:(UIViewController *)sender storyboardViewControlerToPresent:(NSString *)name callback:(void (^)(void))callback
{
    if (self = [super init]) {
        self.sender = sender;
        self.callback = callback;
        self.storyboardViewId = name;
    }
    return self;
}

#pragma mark Guesture Recognizer
-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.sender.view];
    CGPoint velocity = [recognizer velocityInView:self.sender.view];
    
    self.lastKnownVelocity = velocity;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (self.interactiveTransitionUnderway == NO) {
                self.interactive = YES;
                
                if (![self.sender presentedViewController]) {
                    [self presentMenu];
                } else {
                    [self.sender dismissViewControllerAnimated:YES completion:self.callback];
                }
            }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = location.x / CGRectGetWidth(self.sender.view.bounds);
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (self.interactiveTransitionInteracting) {
                if (self.presenting) {
                    if (velocity.x > 0) {
                        [self finishInteractiveTransition];
                    } else {
                        [self cancelInteractiveTransition];
                    }
                } else {
                    if (velocity.x < 0) {
                        [self finishInteractiveTransition];
                    } else {
                        [self cancelInteractiveTransition];
                    }
                }
            }
            break;
        default:
            break;
    }
}

-(void)presentMenu
{
    self.presenting = YES;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *settings = [sb instantiateViewControllerWithIdentifier:self.storyboardViewId];
    settings.modalPresentationStyle = UIModalPresentationCustom;
    settings.transitioningDelegate = self;
    
    [self.sender presentViewController:settings animated:YES completion:self.callback];
}

-(void)ensureAnimationCompletesWithFrame:(CGRect)endFrame
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    double delayInSeconds = [self transitionDuration:self.transitionContext];
    UIView * animating = self.snapshot ? self.snapshot : self.presenting ? fromViewController.view : toViewController.view;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        id<UIViewControllerContextTransitioning> blockContext = self.transitionContext;
        UIDynamicAnimator *blockAnimator = self.animator;
        if (blockAnimator && blockContext == transitionContext) {
            [transitionContext completeTransition:YES];
            animating.frame = endFrame;
        }
    });
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (void)animationEnded:(BOOL)transitionCompleted
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!self.presenting) {
        [self.dismissTap.view removeGestureRecognizer:self.dismissTap];
        self.dismissTap = nil;
        self.sender.navigationController.topViewController.navigationItem.leftBarButtonItem.enabled = YES;
    } else {
        UIView *panView = self.snapshot ? self.snapshot : self.sender.view;
        UIScreenEdgePanGestureRecognizer *pgr = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
        pgr.edges = UIRectEdgeRight;
        [panView addGestureRecognizer:pgr];
    }
    fromViewController.view.userInteractionEnabled = YES;
    toViewController.view.userInteractionEnabled = YES;
    self.interactive = NO;
    self.presenting = NO;
    self.transitionContext = nil;
    self.completing = NO;
    self.interactiveTransitionInteracting = NO;
    self.interactiveTransitionUnderway = NO;
    
    [self.animator removeAllBehaviors], self.animator.delegate = nil, self.animator = nil;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.75f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    if (self.interactive) {
        // nop as per documentation
    }
    else {
        self.completing = YES;
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect startFrame = [[transitionContext containerView] bounds];
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
        self.animator.delegate = self;
        UIView *animating;
        UIView *bottom;
        CGFloat dx = 20, fa = 1;
        if (self.presenting) {
            bottom = toViewController.view;
            animating = [fromViewController.view resizableSnapshotViewFromRect:startFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            self.main = fromViewController.view;
            
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:fromViewController.view.bounds];
            animating.layer.masksToBounds = NO;
            animating.layer.shadowColor = [UIColor blackColor].CGColor;
            animating.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
            animating.layer.shadowOpacity = 0.5f;
            animating.layer.shadowPath = shadowPath.CGPath;
            
            self.dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeModal)];
            [animating addGestureRecognizer:self.dismissTap];
            
            endFrame.origin.x += CGRectGetWidth(self.transitionContext.containerView.bounds) - 50;
            CGRect sFrame = startFrame;
            sFrame.origin.x -= dx;
            bottom.frame = sFrame;
            bottom.alpha = 0.5;
        } else {
            startFrame.origin.x += CGRectGetWidth(self.transitionContext.containerView.bounds) - 50;
            toViewController.view.frame = startFrame;
            fromViewController.view.frame = endFrame;
            animating = toViewController.view;
            bottom = fromViewController.view;
            dx = -20;
            fa = 0.5;
        }
        [transitionContext.containerView addSubview:self.main];
        [transitionContext.containerView addSubview:bottom];
        [transitionContext.containerView addSubview:animating];
        self.snapshot = animating;
        
        CGPoint anchor = (self.isPresenting) ? CGPointMake((2 * CGRectGetWidth(animating.bounds)) - 50, animating.center.y) : CGPointMake(0, animating.center.y);
        self.b = [[BouncingViewBehavior alloc] initWithItem:animating anchor:anchor];
        [self.animator addBehavior:self.b];
        
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] / 3.0f
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                                  animations:^{
                                      CGRect sFrame = bottom.frame;
                                      sFrame.origin.x += dx;
                                      bottom.frame = sFrame;
                                      bottom.alpha = fa;
                                  }
                                  completion:nil];
        
        [self ensureAnimationCompletesWithFrame:endFrame];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    self.interactiveTransitionInteracting = YES;
    self.interactiveTransitionUnderway = YES;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    CGRect frame = [[transitionContext containerView] bounds];
    UIView *animating;
    UIView *bottom;
    CGFloat dx = 20;
    if (self.presenting) {
        bottom = toViewController.view;
        animating = [fromViewController.view resizableSnapshotViewFromRect:frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        self.main = fromViewController.view;
        self.dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeModal)];
        [animating addGestureRecognizer:self.dismissTap];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:fromViewController.view.bounds];
        animating.layer.masksToBounds = NO;
        animating.layer.shadowColor = [UIColor blackColor].CGColor;
        animating.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        animating.layer.shadowOpacity = 0.5f;
        animating.layer.shadowPath = shadowPath.CGPath;
        
        CGRect sFrame = frame;
        sFrame.origin.x -= dx;
        bottom.frame = sFrame;
        bottom.alpha = 0.5;
    } else {
        animating = toViewController.view;
        bottom = fromViewController.view;
        frame.origin.x += CGRectGetWidth([[transitionContext containerView] bounds]) - 50;
    }
    [transitionContext.containerView addSubview:self.main];
    [transitionContext.containerView addSubview:bottom];
    [transitionContext.containerView addSubview:animating];
    
    animating.frame = frame;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
    self.animator.delegate = self;
    
    id <UIDynamicItem> dynamicItem = animating;
    
    if (self.presenting) {
        self.ab = [[UIAttachmentBehavior alloc] initWithItem:dynamicItem attachedToAnchor:CGPointMake(0.0f, CGRectGetMidY(transitionContext.containerView.bounds))];
    } else {
        self.ab = [[UIAttachmentBehavior alloc] initWithItem:dynamicItem attachedToAnchor:CGPointMake(CGRectGetWidth(transitionContext.containerView.bounds) - 50, CGRectGetMidY(transitionContext.containerView.bounds))];
    }
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[dynamicItem]];
    [collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -1 * (CGRectGetWidth(transitionContext.containerView.bounds) - 50))];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[dynamicItem]];
    itemBehaviour.elasticity = 0.5f;
    
    [self.animator addBehavior:collisionBehaviour];
    [self.animator addBehavior:itemBehaviour];
    [self.animator addBehavior:self.ab];
    self.snapshot = animating;
    self.interactiveSettings = bottom;
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    self.ab.anchorPoint = CGPointMake(CGRectGetWidth(self.transitionContext.containerView.bounds) * percentComplete, CGRectGetMidY(self.transitionContext.containerView.bounds));
    
    CGRect sFrame = self.interactiveSettings.frame;
    sFrame.origin.x = -20 + (20 * percentComplete);
    self.interactiveSettings.frame = sFrame;
    self.interactiveSettings.alpha = 0.5 + (0.5 * percentComplete);
}

- (void)finishInteractiveTransition
{
    self.interactiveTransitionInteracting = NO;
    self.completing = YES;
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    [self.animator removeBehavior:self.ab];
    CGRect endFrame = transitionContext.containerView.bounds;
    
    id<UIDynamicItem> dynamicItem = self.snapshot;
    CGFloat gravityXComponent = 0.0f;
    CGFloat dx = 0, fa = 1;
    if (self.presenting) {
        gravityXComponent = 5.0f;
        endFrame.origin.x += CGRectGetWidth(endFrame) - 50;
    } else {
        gravityXComponent = -5.0f;
        dx = -20;
        fa = 0.5;
    }
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[dynamicItem]];
    gravityBehaviour.gravityDirection = CGVectorMake(gravityXComponent, 0.0f);
    
    UIPushBehavior *pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[dynamicItem] mode:UIPushBehaviorModeInstantaneous];
    pushBehaviour.pushDirection = CGVectorMake(self.lastKnownVelocity.x / 10.0f, 0.0f);
    
    [self.animator addBehavior:gravityBehaviour];
    [self.animator addBehavior:pushBehaviour];
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] / 3.0f
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:^{
                                  CGRect sFrame = self.interactiveSettings.frame;
                                  sFrame.origin.x = dx;
                                  self.interactiveSettings.frame = sFrame;
                                  self.interactiveSettings.alpha = fa;
                              }
                              completion:nil];
    
    [self ensureAnimationCompletesWithFrame:endFrame];
}

- (void)cancelInteractiveTransition
{
    self.interactiveTransitionInteracting = NO;
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    [self.animator removeBehavior:self.ab];

    CGRect endFrame = transitionContext.containerView.bounds;
    
    id<UIDynamicItem> dynamicItem = self.snapshot;
    CGFloat gravityXComponent = 0.0f;
    
    if (self.presenting) {
        gravityXComponent = -5.0f;
    } else {
        gravityXComponent = 5.0f;
        endFrame.origin.x += CGRectGetWidth(endFrame) - 50;
    }
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[dynamicItem]];
    gravityBehaviour.gravityDirection = CGVectorMake(gravityXComponent, 0.0f);
    
    UIPushBehavior *pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[dynamicItem] mode:UIPushBehaviorModeInstantaneous];
    pushBehaviour.pushDirection = CGVectorMake(self.lastKnownVelocity.x / 10.0f, 0.0f);
    
    [self.animator addBehavior:gravityBehaviour];
    [self.animator addBehavior:pushBehaviour];
    
    [self ensureAnimationCompletesWithFrame:endFrame];
}

#pragma mark - UIDynamicAnimatorDelegate Methods

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    // We need this check to determine if the user is still interacting with the transition (ie: they stopped moving their finger)
    if (!self.interactiveTransitionInteracting) {
        [self.transitionContext completeTransition:self.completing];
    }
}

- (void)completeModal
{
    self.presenting = NO;
    [self.sender dismissViewControllerAnimated:YES completion:^{
        if (self.callback) {
            self.callback();
        }
    }];
}

@end
