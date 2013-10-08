//
//  BackButton.m
//  Ratio
//
//  Created by Matthew Hillman on 10/5/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

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
    UIBezierPath *backArrow = [UIBezierPath bezierPath];
    [backArrow moveToPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect) + 3)];
    [backArrow addLineToPoint:CGPointMake(CGRectGetMinX(rect) + 3, CGRectGetMidY(rect))];
    [backArrow addLineToPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect) - 3)];
    [[UIColor whiteColor] setStroke];
    backArrow.lineWidth = 3;
    [backArrow stroke];
}

@end
