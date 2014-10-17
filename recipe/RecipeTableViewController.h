//
//  RecipeTableViewController.h
//  recipe
//
//  Created by Matt Tang on 10/3/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TheRecipes;

@interface RecipeTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *recipes;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContect;

@end
