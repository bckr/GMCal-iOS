//
//  Calendar.h
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBClass;
@interface NBSchedule : NSObject

+ (NSDateComponents *)timeForPeriod:(int)period;
+ (NSString *)dayForPeriod:(int)period;
+ (UIColor *)colorForTypeOfClass:(NBClass *)myClass;

@end
