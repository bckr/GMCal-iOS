//
//  NBNewsItemCell.m
//  GM Calendar
//
//  Created by Nils Becker on 2/27/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsItemCell.h"
#import "NBIndicatorView.h"

@implementation NBNewsItemCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _author = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_author];
        
        _date = [[UILabel alloc] initWithFrame:CGRectZero];
        _date.textAlignment = NSTextAlignmentRight;
        [[self contentView] addSubview:_date];
        
        _readIndicator = [[NBIndicatorView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_readIndicator];
        
        _newsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _newsTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _newsTitle.numberOfLines = 2;
        [[self contentView] addSubview:_newsTitle];
        
        _newsType = [[UILabel alloc] initWithFrame:CGRectZero];
        _newsType.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [[self contentView] addSubview:_newsType];
        
        _newsMeta = [[UILabel alloc] initWithFrame:CGRectZero];
        _newsMeta.lineBreakMode = NSLineBreakByTruncatingTail;
        [[self contentView] addSubview:_newsMeta];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setRead:(BOOL)read {
    _read = read;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
}

#define CELL_PADDING 10
#define LABEL_PADDING_LEFT_UNREAD 30
#define LABEL_PADDING_LEFT_READ 10
#define MAX_TEXT_WIDTH 250
#define READ_INDICATOR_WIDTH 10
#define READ_INDICATOR_HEIGHT 10
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIColor *titleColor;
    UIColor *authorColor;
    UIColor *dateColor;
    
    if (self.selected || self.highlighted)
    {
        titleColor = [UIColor whiteColor];
        authorColor = [UIColor whiteColor];
        dateColor = [UIColor whiteColor];
    } else {
        titleColor = [UIColor blackColor];
        authorColor = [UIColor grayColor];
        dateColor = [UIColor blueColor];
    }
    
    CGRect readIndicatorFrame = CGRectMake(CELL_PADDING, self.bounds.size.height / 2 - READ_INDICATOR_HEIGHT / 2, READ_INDICATOR_WIDTH, READ_INDICATOR_HEIGHT);
    [_readIndicator setFrame:readIndicatorFrame];
    
    unsigned leftPadding = _read ? LABEL_PADDING_LEFT_READ : LABEL_PADDING_LEFT_UNREAD;
    
    CGRect titleFrame = CGRectMake(leftPadding, CELL_PADDING, 250, 0);
    [_newsTitle setFrame:titleFrame];
    [_newsTitle setFont:[UIFont systemFontOfSize:16.00]];
    [_newsTitle setTextColor:titleColor];
    [_newsTitle setBackgroundColor:[UIColor clearColor]];
    [_newsTitle sizeToFit];
    
    if (_newsTitle.frame.size.height > 21) {
        CGRect metaFrame = CGRectMake(leftPadding, 52, MAX_TEXT_WIDTH + LABEL_PADDING_LEFT_UNREAD - leftPadding, 15);
        [_newsMeta setFrame:metaFrame];
        _newsMeta.lineBreakMode = NSLineBreakByTruncatingTail;
        _newsMeta.numberOfLines = 1;
    } else {
        CGRect metaFrame  = CGRectMake(leftPadding, 32, MAX_TEXT_WIDTH + LABEL_PADDING_LEFT_UNREAD - leftPadding, 15);
        [_newsMeta setFrame:metaFrame];
        _newsMeta.lineBreakMode = NSLineBreakByWordWrapping;
        _newsMeta.numberOfLines = 2;
        [_newsMeta sizeToFit];
    }
    
    self.readIndicator.hidden = self.read ? YES : NO;
    
    [_newsMeta setBackgroundColor:[UIColor clearColor]];
    [_newsMeta setTextColor:authorColor];
    [_newsMeta setFont:[UIFont systemFontOfSize:13.0]];
}

@end
