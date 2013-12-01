//
//  RTORatio.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTOIngredient.h"
@interface RTORatio : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *ingredients; //of RTOIngredient
@property (nonatomic, readonly) CGFloat ratioTotal;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSString *variations;

- (id)initWithRatioDict:(NSDictionary *)dict;
- (id)initWithTestData;
- (BOOL)canSetAmountByTotal;
- (NSArray *)makes;
- (NSString *)totalAsString;
- (UIBezierPath *)sliceForIngredient:(RTOIngredient *)ingredient withCenter:(CGPoint)center andRadius:(CGFloat)radius;
- (void)resetAmounts;
@end
