//
//  Ingredient.h
//  Ratio
//
//  Created by Matthew Hillman on 11/6/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ratio;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) Ratio *makes;

@end
