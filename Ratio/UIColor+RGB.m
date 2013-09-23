//
//  UIColor+RGB.m
//  Ratio
//
//  Created by Matthew Hillman on 9/23/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)
+ (UIColor *)colorForR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a
{
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a];
}
@end
