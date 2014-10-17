//
//  Recipe.h
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient, Item, Step;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *steps;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addStepsObject:(Step *)value;
- (void)removeStepsObject:(Step *)value;
- (void)addSteps:(NSSet *)values;
- (void)removeSteps:(NSSet *)values;

- (NSInteger)total;

- (NSString *)stringOfIngredients;

- (NSString *)stringOfItems;

- (NSString *)stringOfStepForRow:(NSInteger)row;

- (NSNumber *)timeOfStepAtRow:(NSInteger)row;

@end
