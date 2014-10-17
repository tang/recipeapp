//
//  DisplayRecipeViewController.h
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Recipe;
@import CoreData;

@interface DisplayRecipeViewController : UIViewController

@property (nonatomic, strong) NSDictionary *recipe;
@property (nonatomic, strong) Recipe *theRecipe;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
