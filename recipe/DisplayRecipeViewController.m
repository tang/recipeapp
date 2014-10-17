//
//  DisplayRecipeViewController.m
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

/*
 Contains Control and Table views
 Lists the parts of the current recipe
 */

#import "DisplayRecipeViewController.h"
#import "ContainerControlView.h"
#import "RecTableViewCell.h"
#import "Recipe.h"
#import "Step.h"
#import "FetchedResultsControllerDataSource.h"

@interface DisplayRecipeViewController () <UITableViewDelegate, FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ContainerControlView *infoV;
@property (nonatomic, strong) NSArray *verticalConstraints;
@property (nonatomic, strong) FetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end

@implementation DisplayRecipeViewController {
    NSInteger _remainingTimeInSeconds;
    NSTimer *_countDownTimer;
}

static NSString *CellIdentifier = @"RecTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.theRecipe.name;
    
    _infoV = [[ContainerControlView alloc] init];
    _infoV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_infoV];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView registerClass:[RecTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:_tableView];
    
    [self setUpDataSource];
    
    // Use visual constaint to lay out the views
    NSDictionary *views = NSDictionaryOfVariableBindings(_infoV, _tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_infoV]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self updateViewConstraints];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
//    NSLog(@"updateViewConstraints called");
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_infoV, _tableView);
    
    NSMutableDictionary *metrics = [NSMutableDictionary dictionary];
    
    // Adjust the top space depending on which size class is active
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        [metrics setObject:@64 forKey:@"topSpace"];
    } else if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        [metrics setObject:@0 forKey:@"topSpace"];
    } else {
        [metrics setObject:@20 forKey:@"topSpace"];
    }
    
    [self.view removeConstraints:self.verticalConstraints];
    self.verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topSpace)-[_infoV(40.0)][_tableView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views];
    
    [self.view addConstraints:self.verticalConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRecipe:(NSDictionary *)recipe
{
    if (_recipe != recipe) {
        _recipe = [recipe copy];
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
    }
}

- (void)setUpDataSource
{
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTable:self.tableView];
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.cellIdentifier = CellIdentifier;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = [NSPredicate predicateWithFormat:@"self == %@", self.theRecipe];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;

}

- (NSString *)textForRow:(NSInteger)row withRecipe:(Recipe *)recipe
{
    if (row == 0) {
        return [recipe stringOfIngredients];
    } else if (row == 1) {
        return [recipe stringOfItems];
    }
    
    return [recipe stringOfStepForRow:row];
}

- (NSString *)titleForRow:(NSInteger)row
{
    NSArray *titles = @[@"Ingredients", @"Items", @"Step"];
    
    if (row == 0) {
        return titles[row];
    } else if (row == 1) {
        return titles[row];
    } else {
        return [NSString stringWithFormat:@"%@ %d", titles[2], (int)row - 1];
    }
}

#pragma mark - FetchedResulsControllerDataSource delegate

- (void)configureCell:(id)cell withObject:(id)object forIndexPath:(NSIndexPath *)indexPath
{
    Recipe *recipe = (Recipe *)object;
    self.theRecipe = recipe;
    
    ((RecTableViewCell *)cell).mainLabel.text = [self textForRow:indexPath.row withRecipe:self.theRecipe];
    ((RecTableViewCell *)cell).titleLabel.text = [self titleForRow:indexPath.row];
    ((RecTableViewCell *)cell).time = [self.theRecipe timeOfStepAtRow:indexPath.row];
}

#pragma mark - Table view data source

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    RecTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if (!cell) {
//        cell = [[RecTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.mainLabel.text = [self stringForRow:indexPath.row];
//    
//    cell.titleLabel.text = [self titleForRow:indexPath.row];
//    
//    cell.time = [self timeForRow:indexPath.row];
//    
//    return cell;
//}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecTableViewCell *cell = [[RecTableViewCell alloc] init];
    
    cell.mainLabel.text = [self textForRow:indexPath.row withRecipe:self.theRecipe];
    cell.titleLabel.text = [self titleForRow:indexPath.row];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Return height with a little extra padding
    return height += 4.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearTimer];
    
    // Don't run the timer for the Ingredients or Items rows
    if (indexPath.row <= 1) {
        return;
    }
    
    RecTableViewCell *cell = (RecTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Don't run the timer if the Time is 0
    if ([cell.time intValue] == 0) {
        return;
    }
    
    // Set initial time to label in the infoV view
    _infoV.label.text = [NSString stringWithFormat:@"%02d:00", [cell.time intValue]];
    
    _remainingTimeInSeconds = [cell.time integerValue] * 60;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
}

#pragma mark - Timer methods

- (void)updateTimer
{
    if (_remainingTimeInSeconds <= 0) {
        
        [self clearTimer];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Step Finished!"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        
        // Add ok action to alertController
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    _remainingTimeInSeconds -= 1;
    
    int seconds = (int)_remainingTimeInSeconds;
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    
    _infoV.label.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
//    NSLog(@"%d", (int)_remainingTimeInSeconds);
    
}

- (void)clearTimer
{
    // Stop the timer
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    
    // Reset the label to 00:00
    _infoV.label.text = @"00:00";

    // Set the Remaining time instance variable to 0
    _remainingTimeInSeconds = 0;

}
@end
