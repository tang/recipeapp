//
//  RecTableViewCell.m
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "RecTableViewCell.h"

@implementation RecTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _mainLabel.numberOfLines = 0;
        _mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _mainLabel.backgroundColor = [UIColor lightGrayColor];

        [self.contentView addSubview:_mainLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 
        NSDictionary *views = NSDictionaryOfVariableBindings(_mainLabel, _titleLabel);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[_mainLabel]-6-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_titleLabel]->=6-[_mainLabel]-6-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0.0f]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView has the correct frame set
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
//    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textLabel.frame);
    self.mainLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.mainLabel.frame);

}
@end
