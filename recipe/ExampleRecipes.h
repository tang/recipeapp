//
//  ExampleRecipes.h
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

/*
    Adds some example receipes to the database
 */

#import <Foundation/Foundation.h>
@import CoreData;

@interface ExampleRecipes : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)addScrambledEggsRecipe;

@end
