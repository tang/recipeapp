//
//  Recipe.m
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "Recipe.h"
#import "Ingredient.h"
#import "Item.h"
#import "Step.h"


@implementation Recipe

@dynamic name;
@dynamic ingredients;
@dynamic items;
@dynamic steps;

- (NSInteger)total
{
    
    return self.steps.count + 2;
    
}

- (NSString *)stringOfIngredients
{
    if (self.ingredients.count == 0) {
        return @"No ingredients";
    }
    
    NSMutableArray *ingredsArray = [NSMutableArray array];
    
    for (Ingredient *theIngredient in self.ingredients) {
        [ingredsArray addObject:[NSString stringWithFormat:@"%@ - %@", theIngredient.name, theIngredient.amount]];
    }
    
    return [ingredsArray componentsJoinedByString:@"\n"];
    
}

- (NSString *)stringOfItems
{
    if (self.items.count == 0) {
        return @"No items";
    }
    
    NSMutableArray *itemsArray = [NSMutableArray array];

    for (Item *theItem in self.items) {
        [itemsArray addObject:[NSString stringWithFormat:@"%@", theItem.name]];
    }
    
    return [itemsArray componentsJoinedByString:@"\n"];
}

- (NSString *)stringOfStepForRow:(NSInteger)row
{
    NSArray *found = [self stepAtRow:row];
    
    if (found.count > 0) {
        Step *step = [found firstObject];
        return [NSString stringWithFormat:@"Time (min): %@\n%@", step.time, step.desc];
    }
    
    return @"No steps";
}

- (NSNumber *)timeOfStepAtRow:(NSInteger)row
{
    NSArray *found = [self stepAtRow:row];

    if (found.count > 0) {
        Step *step = [found firstObject];
        return step.time;
    }
    
    return @0;
}

- (NSArray *)stepAtRow:(NSInteger)row
{
    NSArray *stepsArray = [self.steps allObjects];
    
    // Subtract 2 to account for Ingredients and Items rows
    int order = (int)row - 2;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order == %@", @(order)];
    
    return [stepsArray filteredArrayUsingPredicate:predicate];
}

@end
