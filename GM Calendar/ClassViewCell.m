//
//  ClassViewCell.m
//  GM Calendar
//
//  Created by Nils Becker on 1/17/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "ClassViewCell.h"

@implementation ClassViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
