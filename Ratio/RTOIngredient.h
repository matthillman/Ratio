//
//  RTOIngredient.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTOAmount.h"

@interface RTOIngredient : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) RTOAmount *amountInRecipe;
@property (nonatomic, strong) NSNumber *defaultAmount;

- (id)initWithIngredientDict:(NSDictionary *)dict;
- (void)setRecipeUnits:(NSString *)units;
@end
