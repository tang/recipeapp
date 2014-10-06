//
//  ContainerControlView.m
//  recipe
//
//  Created by Matt Tang on 10/4/14.
//  Copyright (c) 2014 kauai. All rights reserved.
//

#import "ContainerControlView.h"


@implementation ContainerControlView {
    UIButton *_button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)intrinsicContentSize
{
    CGSize size = [_label intrinsicContentSize];
    
//    NSLog(@"size: %@", NSStringFromCGSize(size));
    
    size.height += 40;
    
//    NSLog(@"size after: %@", NSStringFromCGSize(size));

    return size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor lightGrayColor];
        _label.text = @"00:00";
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        
        // Add Start/Stop button later
//        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [_button setBackgroundColor:[UIColor lightGrayColor]];
//        [_button setTitle:@"Start" forState:UIControlStateNormal];
//        _button.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addSubview:_button];
        
//        NSDictionary *views = NSDictionaryOfVariableBindings(_label, _button);
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[_button(60.0)]->=10-[_label]-6-|"
//                                                                     options:0
//                                                                     metrics:nil
//                                                                       views:views]];
//        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_button]-6-|"
//                                                                     options:0
//                                                                     metrics:nil
//                                                                       views:views]];

        NSDictionary *views = NSDictionaryOfVariableBindings(_label);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=6-[_label]-6-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        // Center _label vertically to the View
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        backgroundView.contentView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
//        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addSubview:backgroundView];
//        NSDictionary *views = @{@"backgroundView" : backgroundView};
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[backgroundView]|" options:0 metrics:nil views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:views]];
//        
//        _label = [[UILabel alloc] init];
//        _label.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addSubview:_label];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    }
//    return self;
//}

@end
