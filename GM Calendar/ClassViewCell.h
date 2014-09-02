//
//  ClassViewCell.h
//  GM Calendar
//
//  Created by Nils Becker on 1/17/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *classNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *classLecturerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *classRoomLabel;

@end
