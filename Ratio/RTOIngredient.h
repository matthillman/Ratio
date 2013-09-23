//
//  RTOIngredient.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTOIngredient : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSNumber *amount;
@property (nonatomic, strong) UIColor *color;
@end
