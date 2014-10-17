//
//  Step.h
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) Recipe *recipe;

@end
