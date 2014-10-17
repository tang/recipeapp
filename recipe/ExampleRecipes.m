//
//  ExampleRecipes.m
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "ExampleRecipes.h"
#import "Recipe.h"
#import "Item.h"
#import "Step.h"
#import "Ingredient.h"

@implementation ExampleRecipes

- (id)init {
    if ( self = [super init] ) {

    }
    
    return self;
}

- (void)addScrambledEggsRecipe
{
    NSArray *items = @[@"Bowl", @"Serving Plate", @"Stove", @"Whisk"];
    NSDictionary *ingreds = @{
                              @"Eggs": @"4",
                              @"Salt": @"1 teaspoon",
                              @"Pepper": @"1 teaspoon",
                              @"Olive Oil": @"2 teaspoons"
                              };
    NSDictionary *steps = @{
                            @"Crack all of the eggs into a bowl": @1,
                            @"Whisk eggs until the yolks are mixed together": @1,
                            @"Turn on stove to medium-high": @5,
                            @"Pour eggs into pan and stir": @4,
                            @"Place eggs onto serving plate": @0
                            };
    
    [self saveRecipeToDB:@"Scrambled Eggs" ingredients:ingreds items:items steps:steps];
}

- (void)addSpaghettiRecipe
{
    
}

- (void)saveRecipeToDB:(NSString *)recipeName ingredients:(NSDictionary *)ingredients items:(NSArray *)items steps:(NSDictionary *)steps
{

    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    // Set recipe name
    recipe.name = recipeName;
    
    // Build and Save items NSSet
    NSMutableSet *saveItems = [[NSMutableSet alloc] init];
    for (NSString *item in items) {
        Item *itemEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                         inManagedObjectContext:self.managedObjectContext];
        itemEntity.name = item;
        [saveItems addObject:itemEntity];
    }
    
    [recipe addItems:saveItems];
    
    // Build an Save ingredients NSSet
    NSMutableSet *saveIngredients = [[NSMutableSet alloc] init];
    [ingredients enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        Ingredient *ingred = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient"
                                                           inManagedObjectContext:self.managedObjectContext];
        ingred.name = [key description];
        ingred.amount = [obj description];
        
        [saveIngredients addObject:ingred];
        
    }];
    
    [recipe addIngredients:saveIngredients];
    
    // Build an Save steps NSSet
    NSMutableSet *saveSteps = [[NSMutableSet alloc] init];
    
    // Order will be 0 based
    __block int order = 0;
    
    [steps enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        Step *step = [NSEntityDescription insertNewObjectForEntityForName:@"Step"
                                                   inManagedObjectContext:self.managedObjectContext];
        step.desc = [key description];
        step.time = @([[obj description] integerValue]);
        step.order = @(order);
        
        order++;
        [saveSteps addObject:step];
        
    }];
    
    [recipe addSteps:saveSteps];

    NSError *error;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"save error: %@", [error localizedDescription]);
    } else {
        NSLog(@"saved recipe: %@", recipeName);
    }
    
}

@end
