//
//  BouncingViewBehavior.h
//  Ratio
//
//  Created by Matthew Hillman on 10/3/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BouncingViewBehavior : UIDynamicBehavior
@property (nonatomic, assign) CGPoint anchor;
- (void)cleanUpAnimation;
- (BouncingViewBehavior *)initWithItem:(id <UIDynamicItem>)item anchor:(CGPoint)anchor;
- (BouncingViewBehavior *)initWithItem:(id <UIDynamicItem>)item anchor:(CGPoint)anchor attachedToTop:(BOOL)top;
@end
