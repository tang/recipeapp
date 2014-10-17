//
//  RecipeTableViewController.m
//  recipe
//
//  Created by Matt Tang on 10/3/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "DisplayRecipeViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Recipe.h"

@interface RecipeTableViewController () <FetchedResultsControllerDataSourceDelegate>
@property (nonatomic, strong) FetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@end

@implementation RecipeTableViewController

static NSString *CellIdentifier = @"RecipeTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Recipes";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self setUpDataSource];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRecipes:(NSArray *)recipes
{
    if (_recipes != recipes) {
        _recipes = recipes;
        // Reload the table if the view has already been loaded into memory
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
    }
}

- (void)setUpDataSource
{
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTable:self.tableView];
    self.fetchedResultsControllerDataSource.cellIdentifier = CellIdentifier;
    self.fetchedResultsControllerDataSource.delegate = self;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSFetchedResultsController *fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContect sectionNameKeyPath:nil cacheName:nil];
        
    self.fetchedResultsControllerDataSource.fetchedResultsController = fetchedResults;

}

#pragma mark - FetchedResultsControllerDataSource delegate

- (void)configureCell:(id)cell withObject:(id)object forIndexPath:(NSIndexPath *)indexPath
{
    Recipe *recipe = (Recipe *)object;
//    UITableViewCell *theCell = cell;
//    theCell.textLabel.text = recipe.name;
    ((UITableViewCell *)cell).textLabel.text = recipe.name;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplayRecipeViewController *controller = [[DisplayRecipeViewController alloc] init];
    controller.theRecipe = [self.fetchedResultsControllerDataSource selectedItem];
    controller.managedObjectContext = self.managedObjectContect;
    [self showDetailViewController:controller sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
