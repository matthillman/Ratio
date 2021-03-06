//
//  RTOAmount.m
//  Ratio
//
//  Created by Matthew Hillman on 9/26/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOAmount.h"
#import "RTOUnitConverter.h"
#import "RTOIngredient.h"

@implementation RTOAmount
+ (RTOAmount *)amountForQuantity:(NSNumber *)quantity unit:(NSString *)unit
{
    return [[RTOAmount alloc] initWithQuantity:quantity unit:unit];
}
- (RTOAmount *)initWithQuantity:(NSNumber *)quantity unit:(NSString *)unit
{
    self = [self init];
    if (self) {
        self.quantity = quantity;
        self.unit = unit;
    }
    return self;
}

- (RTOAmount *)convertAmountOf:(RTOIngredient *)ingredient toUnit:(NSString *)unit
{
    return [RTOUnitConverter convertAmount:self of:ingredient toUnit:unit];
}

- (NSString *)quantityAsString
{
    return [[RTOUnitConverter formatterForUnit:self.unit] stringFromNumber:self.quantity];
}

- (NSString *)unit
{
    return [_unit lowercaseString];
}

- (void)setQuantity:(NSNumber *)quantity
{
    _quantity = quantity;
}
@end
