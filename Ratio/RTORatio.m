//
//  RTORatio.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTORatio.h"
#import "RTOUnitConverter.h"

@interface RTORatio ()
@property (nonatomic, strong) NSDictionary *total;
@end

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
        _instructions = [dict[@"instructions"] stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        _variations = [dict[@"variations"] stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        NSMutableArray *ingredients = [[NSMutableArray alloc] init];
        for (NSDictionary *ingredient in dict[@"ingredients"]) {
            RTOIngredient *i = [[RTOIngredient alloc] initWithIngredientDict:ingredient];
            [ingredients addObject:i];
        }
        _ingredients = ingredients;
        _total = dict[@"total"];
        _totalQuantity = [[self makes][0] doubleValue];
    }
    return self;
}

- (BOOL)canSetAmountByTotal
{
    return [self.total count];// && ![self.total[@"action"] isEqualToString:@"sum"];
}

- (NSArray *)makes
{
    if ([self.total count]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *amount = [f numberFromString:[NSString stringWithFormat:@"%@", self.total[@"amount"]]];
        NSArray *includedIngredients = [self includedIngredients];
        
        NSString *label = self.total[@"label"];
        NSString *firstItemUnit = [[[(RTOIngredient *)includedIngredients[0] amountInRecipe] unit] mutableCopy];
        
        if ([label isEqualToString:@"volume"] || [label isEqualToString:@"weight"] || [label isEqualToString:@"<same>"]) {
            label = firstItemUnit;
        }
        NSString *action = self.total[@"action"];
        NSString *total = nil;
        
        if ([action isEqualToString:@"sum"]) {
            CGFloat t = 0;
            for (RTOIngredient *i in includedIngredients) {
                RTOAmount *a = [i.amountInRecipe convertAmountOf:i toUnit:firstItemUnit];
                t += [a.quantity floatValue];
            }
            total = [[RTOUnitConverter formatterForUnit:firstItemUnit] stringFromNumber:[[NSNumber alloc] initWithFloat:t]];
        } else {
            NSString *measure = [self.total[@"measure"] isEqualToString:@"volume"] ? @"liters" : [self.total[@"measure"] isEqualToString:@"weight"] ? @"grams" : self.total[@"measure"];
            RTOAmount *ra = [(RTOIngredient *)includedIngredients[0] amountInRecipe];
            RTOAmount *a = [[RTOAmount alloc] initWithQuantity:ra.quantity unit:ra.unit];
            a = [a convertAmountOf:includedIngredients[0] toUnit:measure];
            a.quantity = [NSNumber numberWithFloat:[a.quantity floatValue] / [amount floatValue]];
            NSNumberFormatter *f = nil;
            if ([label isEqualToString:firstItemUnit]) {
                f = [RTOUnitConverter formatterForUnit:firstItemUnit];
                a = [a convertAmountOf:includedIngredients[0] toUnit:firstItemUnit];
            } else {
                f = [[NSNumberFormatter alloc] init];
                [f setRoundingMode:NSNumberFormatterRoundFloor];
                [f setMaximumFractionDigits:0];
            }

            total = [f stringFromNumber:[[NSNumber alloc] initWithFloat:[a.quantity floatValue]]];
        }
        
        return @[total, label];
    }
    
    return nil;
}

- (NSArray *)includedIngredients
{
    return [self.total[@"ingredient"] isEqualToString:@"all"] ? self.ingredients : @[[self ingredientWithName:self.total[@"ingredient"]]];
}

- (NSInteger)step
{
    NSString *label = self.total[@"label"];
    return ([label isEqualToString:@"volume"] || [label isEqualToString:@"weight"] || [label isEqualToString:@"<same>"]) ? 50 : 1;
}

- (void)setTotalQuantity:(CGFloat)totalQuantity
{
    _totalQuantity = totalQuantity;
    CGFloat originalAmount = [[[(RTOIngredient *)[self includedIngredients][0] amountInRecipe] quantity] floatValue];
    CGFloat r =  originalAmount / [[self makes][0] floatValue];
    CGFloat newAmount = r * totalQuantity;
    CGFloat ratio = newAmount / originalAmount;
    for (RTOIngredient *i in self.ingredients) {
        i.amountInRecipe.quantity = [NSNumber numberWithFloat:[i.amountInRecipe.quantity floatValue] * ratio];
    }
}

- (NSString *)totalAsString
{
    NSArray *components = [self makes];
    return [components count] ? [NSString stringWithFormat:@"Makes %@", [[self makes] componentsJoinedByString:@" "]] : nil;
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

- (RTOIngredient *)ingredientWithName:(NSString *)name
{
    for (RTOIngredient *ingredient in self.ingredients) {
        if ([ingredient.name isEqualToString:name]) {
            return ingredient;
        }
    }
    return nil;
}

- (void)resetAmounts
{
    for (RTOIngredient *ingredient in self.ingredients) {
        ingredient.amountInRecipe = nil;
    }
}
@end
