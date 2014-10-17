//
//  FetchedResultsControllerDataSource.h
//  recipe
//
//  Created by Matt Tang on 10/8/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@import UIKit.UITableView;
@import UIKit.UILabel;

@protocol FetchedResultsControllerDataSourceDelegate <NSObject>

- (void)configureCell:(id)cell withObject:(id)object forIndexPath:(NSIndexPath *)indexPath;

@end

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic) BOOL paused;
@property (nonatomic, weak) id <FetchedResultsControllerDataSourceDelegate> delegate;

- (id)initWithTable:(UITableView *)tableView;
- (id)selectedItem;

@end
