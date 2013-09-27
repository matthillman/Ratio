//
//  RTOUnitConverter.m
//  Ratio
//
//  Created by Matthew Hillman on 9/26/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOUnitConverter.h"

@interface RTOUnitConverter ()
@property (nonatomic, strong) NSDictionary *ingredients; // of NSDictionary {"unitList", "plural", "conversion", "singular"}
@property (nonatomic, strong) NSDictionary *volumeScales;
@property (nonatomic, strong) NSDictionary *weightScales;
@property (nonatomic, strong) NSDictionary *unitLists;
@property (nonatomic, strong) NSDictionary *unitFormats;
@end

@implementation RTOUnitConverter

- (RTOUnitConverter *)init
{
    self = [super init];
    if (self) {
        NSString *unitsPath = [[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"];
        NSMutableDictionary *unitPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:unitsPath];
        self.unitLists = [[NSMutableDictionary alloc] initWithDictionary:unitPlist[@"unitLists"]];
        self.volumeScales = unitPlist[@"converter"][@"volume"];
        self.weightScales = unitPlist[@"converter"][@"weight"];
        self.ingredients = unitPlist[@"ingredients"];
        self.unitFormats = unitPlist[@"formats"];
    }
    return self;
}

+ (id)sharedConverter
{
    static RTOUnitConverter *sharedConverter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConverter = [[self alloc] init];
    });
    return sharedConverter;
}

+ (RTOAmount *)convertAmount:(RTOAmount *)amount of:(RTOIngredient *)ingredient toUnit:(NSString *)unit
{
    unit = [unit lowercaseString];
    RTOUnitConverter *converter = [RTOUnitConverter sharedConverter];
    NSDictionary *scale = converter.volumeScales[unit] ? converter.volumeScales : converter.weightScales;
    CGFloat quantity = [amount.quantity floatValue];
    NSString *fromUnit = amount.unit;
    
    if (converter.volumeScales[unit] && converter.weightScales[fromUnit]) {
        quantity /= [(NSNumber *)converter.weightScales[fromUnit] floatValue] * [(NSNumber *)converter.ingredients[ingredient.name][@"conversion"] floatValue];
        fromUnit = @"liters";
    } else if (converter.weightScales[unit] && converter.volumeScales[fromUnit]) {
        quantity *= [(NSNumber *)converter.volumeScales[@"liters"] floatValue] / [(NSNumber *)converter.volumeScales[fromUnit] floatValue] * [(NSNumber *)converter.ingredients[ingredient.name][@"conversion"] floatValue];
        fromUnit = @"kilos";
    }
    
    CGFloat convertedQuantity = quantity * [(NSNumber *)scale[unit] floatValue] / [(NSNumber *)scale[fromUnit] floatValue];
    return [RTOAmount amountForQuantity:[NSNumber numberWithFloat:convertedQuantity] unit:unit];
}

+ (NSArray *)unitListForIngredientNamed:(NSString *)name
{
    RTOUnitConverter *converter = [RTOUnitConverter sharedConverter];
    return converter.unitLists[converter.ingredients[[name lowercaseString]][@"unitList"]];
}

+ (NSString *)formatForUnit:(NSString *)unit
{
    return [[RTOUnitConverter sharedConverter] unitFormats][unit];
}

@end
