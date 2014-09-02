//
//  Lecture.m
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "Lecture.h"

@implementation Lecture

+ (Lecture *)lectureWithContentsOfDict:(NSDictionary *)args {
    Lecture *myLecture = [self new];
    [myLecture setValuesForKeysWithDictionary:args];
    return myLecture;
}

- (NSString *)description {
    NSString *lectureDescription = [NSString stringWithFormat:@"%@ [%@] -> %@: %@", self.ap_day, self.ap_time, self.ap_name_short, self.ap_name_long];
    return lectureDescription;
}

@end
