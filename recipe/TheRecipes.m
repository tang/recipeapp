//
//  TheRecipes.m
//  recipe
//
//  Created by Matt Tang on 10/3/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "TheRecipes.h"

@implementation TheRecipes

- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (NSArray *)arrayOfRecipes
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"json"];
//    NSLog(@"%@", filePath);
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
//    if ([json[@"recipes"] isKindOfClass:[NSArray class]]) {
//        NSLog(@"JSON ARRAY");
//    }
    
    return json[@"recipes"];
}

@end
