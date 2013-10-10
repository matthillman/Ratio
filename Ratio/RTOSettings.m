//
//  RTOSettings.m
//  Ratio
//
//  Created by Matthew Hillman on 10/8/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOSettings.h"

@implementation RTOSettings
+ (BOOL)useMetric
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults boolForKey:@"useMetric"];
}

+ (void)setUseMetric:(BOOL)flag
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:flag forKey:@"useMetric"];
    [standardDefaults synchronize];
}

+ (BOOL)useWeight
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults boolForKey:@"useWeight"];
}

+ (void)setUseWeight:(BOOL)flag
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:flag forKey:@"useWeight"];
    [standardDefaults synchronize];
}

+ (BOOL)useEggs
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults boolForKey:@"useEggs"];
}

+ (void)setUseEggs:(BOOL)flag
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:flag forKey:@"useEggs"];
    [standardDefaults synchronize];
}

@end
