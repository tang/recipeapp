//
//  ContainerRecipeViewController.m
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

/*
 Contains Control and Table views
 Lists the parts of the current recipe
 */

#import "ContainerRecipeViewController.h"
#import "ContainerControlView.h"
#import "RecTableViewCell.h"

@interface ContainerRecipeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ContainerControlView *infoV;
@property (nonatomic, strong) NSArray *verticalConstraints;

@end

@implementation ContainerRecipeViewController {
    NSInteger _remainingTimeInSeconds;
    NSTimer *_countDownTimer;
}

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.recipe[@"name"];
    
    _infoV = [[ContainerControlView alloc] init];
    _infoV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_infoV];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView registerClass:[RecTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:_tableView];
    
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

#pragma mark - Gets string representation of JSON data

- (NSString *)stringForRow:(NSInteger)row
{
    if (row == 0) {
        return [self stringFromIngredients:self.recipe[@"ingredients"]];
    } else if (row == 1) {
        return [self.recipe[@"items"] componentsJoinedByString:@"\n"];
    }
    
    return [self stringFromDirection:self.recipe[@"directions"][row-2]];
}

- (NSString *)stringFromIngredients:(NSArray *)ingredients
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *dict in ingredients) {
        [temp addObject:[NSString stringWithFormat:@"%@ - %@", dict[@"name"], dict[@"amount"]]];
    }
    
    return [temp componentsJoinedByString:@"\n"];
}

- (NSString *)stringFromDirection:(NSDictionary *)direction
{
    NSString *time = direction[@"time-in-minutes"] ? direction[@"time-in-minutes"] : @"0";
    
    return [NSString stringWithFormat:@"Time (min): %@\n%@", time, direction[@"instruction"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int directionsCount = (int)[self.recipe[@"directions"] count];
    
    if (!self.recipe[@"directions"]) {
        return 0;
    }
    
    // 2 accounts for the Ingredients and Items rows
    return directionsCount + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RecTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.mainLabel.text = [self stringForRow:indexPath.row];
    
    cell.titleLabel.text = [self titleForRow:indexPath.row];
    
    cell.time = [self timeForRow:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use default height if there are no directions
    if (!self.recipe[@"directions"]) {
        return 44.0f;
    }
    
    RecTableViewCell *cell = [[RecTableViewCell alloc] init];
    
    cell.mainLabel.text = [self stringForRow:indexPath.row];
    cell.titleLabel.text = [self titleForRow:indexPath.row];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Return height with a little extra padding
    return height += 4.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearTimer];
    
    RecTableViewCell *cell = (RecTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Set initial time to label in the infoV view
    _infoV.label.text = [NSString stringWithFormat:@"%02d:00", [cell.time intValue]];
    
    _remainingTimeInSeconds = [cell.time integerValue] * 60;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
}

#pragma Timer methods

- (NSNumber *)timeForRow:(NSInteger)row
{
    if (row > 1) {
        NSDictionary *direction = self.recipe[@"directions"][row-2];
        
        NSString *time = direction[@"time-in-minutes"] ? direction[@"time-in-minutes"] : @"0";
        
        return [NSNumber numberWithInteger:[time integerValue]];
    }
    
    return @0;
}

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
