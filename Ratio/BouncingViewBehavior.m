//
//  BouncingViewBehavior.m
//  Ratio
//
//  Created by Matthew Hillman on 10/3/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "BouncingViewBehavior.h"

@interface BouncingViewBehavior ()
@property (nonatomic, weak) id <UIDynamicItem> dynamicView;
@property (nonatomic, strong) UIDynamicItemBehavior *bodyBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;
@end
@implementation BouncingViewBehavior
- (BouncingViewBehavior *)initWithItem:(id <UIDynamicItem>)item anchor:(CGPoint)anchor
{
    return [self initWithItem:item anchor:anchor attachedToTop:NO];
}

- (BouncingViewBehavior *)initWithItem:(id <UIDynamicItem>)item anchor:(CGPoint)anchor attachedToTop:(BOOL)top
{
    if (self=[super init]) {
        self.dynamicView = item;
        self.anchor = anchor;
        
        NSArray *items = @[self.dynamicView];
        
        self.bodyBehavior = [[UIDynamicItemBehavior alloc] init];
        self.bodyBehavior.elasticity = .3;
        [self.bodyBehavior addItem:self.dynamicView];
        
        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        CGFloat tf = -1 * [[NSNumber numberWithBool:top] floatValue];
        CGFloat sf = -1 * [[NSNumber numberWithBool:!top] floatValue];
        [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, tf * CGRectGetHeight(self.dynamicView.bounds), sf * CGRectGetWidth(self.dynamicView.bounds))];
        
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
    [self removeAllChildBehaviors];
}

- (void)setAnchor:(CGPoint)anchor
{
    _anchor = anchor;
    [self.attachBehavior setAnchorPoint:_anchor];
}
@end
