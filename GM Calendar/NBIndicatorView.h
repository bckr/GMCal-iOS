//
//  NBClassIndicatorView.h
//  GM Calendar
//
//  Created by Nils Becker on 2/19/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBIndicatorView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) CATextLayer *textLayer;

@end
