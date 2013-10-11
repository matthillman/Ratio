//
//  Egg.m
//  Ratio
//
//  Created by Matthew Hillman on 10/11/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "Egg.h"

@implementation Egg

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect sq = rect;
    if (CGRectGetWidth(rect) != CGRectGetHeight(rect)) {
        CGFloat min = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect));
        CGFloat x = 0, y = 0;
        if (min == CGRectGetWidth(rect)) {
            y = (CGRectGetHeight(rect) - min) / 2.0;
        } else {
            x = (CGRectGetWidth(rect) - min) / 2.0;
        }
        sq = CGRectMake(x, y, min, min);
    }
    CGFloat outerRadius = CGRectGetWidth(sq) / 2.0;
    CGFloat innerRadius = outerRadius / 2.0;
    CGFloat dx = .75 * CGRectGetWidth(sq) / 4.0;
    CGFloat dy = innerRadius * cos(M_PI / 4.0);
    UIBezierPath *egg = [UIBezierPath bezierPath];
    [egg addArcWithCenter:CGPointMake(CGRectGetMidX(sq) + dx, CGRectGetMidY(sq)) radius:outerRadius startAngle:3.0/4.0 * M_PI endAngle:5.0/4.0 * M_PI clockwise:YES];
    [egg addArcWithCenter:CGPointMake(CGRectGetMidX(sq), CGRectGetMidY(sq) - dy) radius:innerRadius startAngle:5.0/4.0 * M_PI endAngle:7.0/4.0 * M_PI clockwise:YES];
    [egg addArcWithCenter:CGPointMake(CGRectGetMidX(sq) - dx, CGRectGetMidY(sq)) radius:outerRadius startAngle:7.0/4.0 * M_PI endAngle:1.0/4.0 * M_PI clockwise:YES];
    [egg addArcWithCenter:CGPointMake(CGRectGetMidX(sq), CGRectGetMidY(sq) + dy) radius:innerRadius startAngle:1.0/4.0 * M_PI endAngle:3.0/4.0 * M_PI clockwise:YES];
    [[UIColor whiteColor] setStroke];
    egg.lineWidth = 2;
    [egg stroke];
    [[UIColor whiteColor] setFill];
    [egg fill];
}

@end
