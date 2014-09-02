//
//  Calendar.m
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "NBSchedule.h"
#import "Lecture.h"
#import "NSDate+Week.h"
#import "NBClass.h"
#import "UIColor+Hex.h"

@implementation NBSchedule

+ (NSDateComponents *)timeForPeriod:(int)period {
    NSDateComponents *timePeriod = [NSDateComponents new];
    
    if (period == 1) {
        timePeriod.hour = 8;
        timePeriod.minute = 30;
        return timePeriod;
    }
    
    int hour = 7 + period;
    timePeriod.hour = hour;
    timePeriod.minute = 0;
    
    return timePeriod;
}

+ (NSString *)dayForPeriod:(int)period {
    NSArray *daysOfWeek = @[@"?", @"Montag", @"Dienstag", @"Mittwoch", @"Donnerstag", @"Freitag", @"Samstag", @"Sonntag"];
    return [daysOfWeek objectAtIndex:period];
}

+ (UIColor *)colorForTypeOfClass:(NBClass *)myClass {
    NSDictionary *colorForType = @{@"UE" : [UIColor colorWithHexString:@"fb890f"],
                                   @"P" : [UIColor colorWithHexString:@"7b72e9"],
                                   @"S" : [UIColor colorWithHexString:@"a5de37"],
                                   @"V" : [UIColor colorWithHexString:@"1b9af7"],
                                   @"T" : [UIColor colorWithHexString:@"fe4251"]};
    return [colorForType valueForKey:myClass.type];
}

@end
