//
//  RTORatioPieView.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTORatioPieView.h"
#import "RTOIngredient.h"

@implementation RTORatioPieView

- (void)drawRect:(CGRect)rect
{
    CGFloat min = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height;
    CGFloat padding = min * .1;
    CGFloat radius = min * .8/2;
    CGPoint center = CGPointMake(self.bounds.size.width/2, padding + radius);
    NSArray *ingredientsToDraw = (self.indexPath) ? @[self.ratio.ingredients[self.indexPath.item-1]] : self.ratio.ingredients;
    
    for (RTOIngredient *ingredient in ingredientsToDraw) {
        UIBezierPath *pie = [self.ratio sliceForIngredient:ingredient withCenter:center andRadius:radius];
        [[UIColor blackColor] setStroke];
        [pie stroke];
        [ingredient.color setFill];
        [pie fill];
    }
}

#pragma mark - Initialization

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
