//
//  RTOIngredient.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOIngredient.h"

@implementation RTOIngredient
- (NSString *)description
{
    NSString *plural = ([self.amount floatValue] > 1) ? @"s" : @"";
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setPositiveFormat:@"0.#"];
    
    return [NSString stringWithFormat:@"%@ part%@ %@", [format stringFromNumber:self.amount], plural, self.name];
}
@end
