//
//  RTOSettings.h
//  Ratio
//
//  Created by Matthew Hillman on 10/8/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTOSettings : NSObject
+ (BOOL)useMetric;
+ (void)setUseMetric:(BOOL)flag;
+ (BOOL)useWeight;
+ (void)setUseWeight:(BOOL)flag;
+ (BOOL)useEggs;
+ (void)setUseEggs:(BOOL)flag;
@end
