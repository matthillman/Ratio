//
//  RTOUnitConverter.h
//  Ratio
//
//  Created by Matthew Hillman on 9/26/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//
//  Only call the class methods!
#import <Foundation/Foundation.h>
#import "RTOAmount.h"
#import "RTOIngredient.h"

@interface RTOUnitConverter : NSObject
+ (RTOAmount *)convertAmount:(RTOAmount *)amount of:(RTOIngredient *)ingredient toUnit:(NSString *)unit;
+ (NSArray *)unitListForIngredientNamed:(NSString *)name;
@end
