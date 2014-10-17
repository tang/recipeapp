//
//  FetchedResultsControllerDataSource.m
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "FetchedResultsControllerDataSource.h"
#import "Recipe.h"

@interface FetchedResultsControllerDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FetchedResultsControllerDataSource

- (id)initWithTable:(UITableView *)tableView
{
    if ( self = [super init] ) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = self.fetchedResultsController.sections[section];

    // Use cell identifier to figure out which Controller is currently the delegate of this Data Source
    // Needs to return rows for all the steps + 1 row for all Ingredients + 1 row for all Items
    if ([self.cellIdentifier isEqualToString:@"Cell"]) {
        Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return [recipe total];
    }
    
    return theSection.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = nil;
    
    // Identifier for DisplayRecipeViewController
    // Return the Recipe object every time
    if ([self.cellIdentifier isEqualToString:@"Cell"]) {
        object = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }

    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object forIndexPath:indexPath];
    return cell;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:NULL];
}

- (id)selectedItem
{
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}

@end

