//
//  NBLoadingIndicatorCell.m
//  GM Calendar
//
//  Created by Nils Becker on 2/11/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBActivityIndicatorCell.h"

@implementation NBActivityIndicatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[self contentView] addSubview:_activityIndicatorView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[self contentView] addSubview:_activityIndicatorView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _activityIndicatorView.frame = frame;
    [_activityIndicatorView startAnimating];
}

@end
