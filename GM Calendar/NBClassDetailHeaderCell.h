//
//  ClassDetailHeaderCell.h
//  GM Calendar
//
//  Created by Nils Becker on 1/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBClassDetailHeaderCell : UITableViewCell

@property (nonatomic, readwrite) UILabel *classNameLabel;
@property (nonatomic, readwrite) UIView *lectureTypeIndicator;

@end