//
//  RTORatio.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTORatio.h"

@implementation RTORatio

- (id)initWithTestData
{
    self = [self init];
    if (self) {
        _name = @"Cookie Dough";
        RTOIngredient *flour = [[RTOIngredient alloc] init];
        flour.name = @"Flour";
        flour.amount = [NSNumber numberWithInt:3];
        flour.color = [UIColor redColor];
        
        RTOIngredient *fat = [[RTOIngredient alloc] init];
        fat.name = @"Fat";
        fat.amount = [NSNumber numberWithInt:2];
        fat.color = [UIColor yellowColor];
        
        RTOIngredient *sugar = [[RTOIngredient alloc] init];
        sugar.name = @"Sugar";
        sugar.amount = [NSNumber numberWithInt:1];
        sugar.color = [UIColor purpleColor];
        
        _ingredients = @[flour, fat, sugar];
    }
    return self;
}

- (id)initWithRatioDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _name = dict[@"title"];
        _instructions = dict[@"instructions"];
        _variations = dict[@"variations"];
        NSMutableArray *ingredients = [[NSMutableArray alloc] init];
        for (NSDictionary *ingredient in dict[@"ingredients"]) {
            RTOIngredient *i = [[RTOIngredient alloc] initWithIngredientDict:ingredient];
            [ingredients addObject:i];
        }
        _ingredients = ingredients;
    }
    return self;
}

@synthesize ratioTotal = _ratioTotal;

- (CGFloat)ratioTotal
{
    if (!_ratioTotal) {
        _ratioTotal = 0;
        for (RTOIngredient *ingredient in self.ingredients) {
            _ratioTotal += [ingredient.amount floatValue];
        }
    }
    return _ratioTotal;
}

- (UIBezierPath *)sliceForIngredient:(RTOIngredient *)ingredient withCenter:(CGPoint)center andRadius:(CGFloat)radius
{
    UIBezierPath *slice;
    CGFloat startAngle = -M_PI/2;
    
    for (RTOIngredient *ing in self.ingredients) {
        CGFloat endAngle = startAngle + (2*M_PI * [ing.amount floatValue] / self.ratioTotal);
        
        if ([ing.name isEqualToString:ingredient.name] && [ing.amount floatValue] > 0) {
            slice = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            [slice addLineToPoint:center];
            [slice closePath];
            break;
        }
        startAngle = endAngle;
    }
    
    return slice;
}
@end
