//
//  Ratio+Create.h
//  Ratio
//
//  Created by Matthew Hillman on 11/6/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "Ratio.h"
#import "RTORatio.h"

@interface Ratio (Create)
+ (Ratio *) createWithRatio:(RTORatio *)ratio name:(NSString *)name inContext:(NSManagedObjectContext *)context;
@end
