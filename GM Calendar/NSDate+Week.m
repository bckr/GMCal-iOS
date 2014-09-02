//
//  NSDate+Week.m
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "NSDate+Week.h"

@implementation NSDate (Week)

- (int)weekday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSWeekdayCalendarUnit fromDate:self];
    return comp.weekday;
}

- (NSDate *)nextDay {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

@end
