//
//  Ratio+Create.m
//  Ratio
//
//  Created by Matthew Hillman on 11/6/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "Ratio+Create.h"
#import "RTOIngredient.h"
#import "Ingredient.h"

@implementation Ratio (Create)
+ (Ratio *)createWithRatio:(RTORatio *)ratio name:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Ratio *r;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ratio"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *results = [context executeFetchRequest:request error:nil];
    if ([results count] == 0) {
    r = [NSEntityDescription insertNewObjectForEntityForName:@"Ratio" inManagedObjectContext:context];
        r.name = name;
        r.ratio = ratio.name;
        for (RTOIngredient *ingredient in ratio.ingredients) {
            Ingredient *ing = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
            ing.name = ingredient.name;
            ing.quantity = ingredient.amountInRecipe.quantity;
            ing.unit = ingredient.amountInRecipe.unit;
        }
    }
    return r;
}
@end
