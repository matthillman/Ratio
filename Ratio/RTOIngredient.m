//
//  RTOIngredient.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOIngredient.h"
#import "UIColor+RGB.h"
#import "RTOUnitConverter.h"

@interface RTOIngredient()
@property (nonatomic, strong) NSNumber *defaultAmount;
@property (nonatomic, strong) NSString *defaultUnits;
@end

@implementation RTOIngredient
- (NSString *)description
{
    if ([self.amount floatValue] > 0) {
        NSString *plural = ([self.amount floatValue] > 1) ? @"s" : @"";
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        [format setPositiveFormat:@"0.#"];
        
        return [NSString stringWithFormat:@"%@ part%@ %@", [format stringFromNumber:self.amount], plural, self.name];
    } else {
        return self.name;
    }
}

+ (UIColor *)colorForCode:(NSInteger)code
{
    NSArray *colors = @[[UIColor colorForR:231 G:76 B:60 A:1.0],   // 1 flour
                        [UIColor colorForR:52 G:152 B:218 A:1.0],  // 2 water
                        [UIColor colorForR:241 G:196 B:15 A:1.0],  // 3 eggs
                        [UIColor colorForR:155 G:89 B:182 A:1.0],  // 4 fat
                        [UIColor colorForR:41 G:128 B:185 A:1.0],  // 5 liquid
                        [UIColor colorForR:52 G:73 B:97 A:1.0],    // 6 sugar
                        [UIColor colorForR:189 G:195 B:199 A:1.0], // 7 egg whites
                        [UIColor colorForR:127 G:140 B:141 A:1.0], // 8 bone
                        [UIColor colorForR:192 G:57 B:43 A:1.0],   // 9 meat
                        [UIColor colorForR:46 G:204 B:113 A:1.0],  // 10 mirepoix
                        [UIColor colorForR:236 G:240 B:241 A:1.0], // 11 salt
                        [UIColor colorForR:129 G:55 B:16 A:1.0]    // 12 chocolate
                       ];

    return colors[code-1];
}

- (id)initWithIngredientDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _name = [NSString stringWithFormat:@"%@", dict[@"name"]];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        _amount = [f numberFromString:[NSString stringWithFormat:@"%@", dict[@"ratio"]]];
        _color = [RTOIngredient colorForCode:[[NSString stringWithFormat:@"%@", dict[@"color"]] integerValue]];
        _defaultAmount = [f numberFromString:[NSString stringWithFormat:@"%@", dict[@"defaultAmount"]]];
        _defaultUnits = [NSString stringWithFormat:@"%@", dict[@"defaultUnit"]];
    }
    return self;
}

- (RTOAmount *)amountInRecipe
{
    if (!_amountInRecipe) {
        _amountInRecipe = [RTOAmount amountForQuantity:self.defaultAmount unit:self.defaultUnits];
    }
    
    return _amountInRecipe;
}

- (void)setRecipeUnits:(NSString *)units
{
    self.amountInRecipe = [RTOUnitConverter convertAmount:self.amountInRecipe of:self toUnit:units];
}

@end