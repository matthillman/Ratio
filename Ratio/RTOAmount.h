//
//  RTOAmount.h
//  Ratio
//
//  Created by Matthew Hillman on 9/26/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTOAmount : NSObject
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSString *unit;

+ (RTOAmount *)amountForQuantity:(NSNumber *)quantity unit:(NSString *)unit;
- (RTOAmount *)initWithQuantity:(NSNumber *)quantity unit:(NSString *)unit;
- (NSString *)quantityAsString;
@end
