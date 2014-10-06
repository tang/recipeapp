//
//  RecTableViewCell.h
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSNumber *time;

@end
