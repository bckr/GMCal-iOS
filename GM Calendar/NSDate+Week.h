//
//  NSDate+Week.h
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Week)

- (int)weekday;
- (NSDate *)nextDay;

@end
