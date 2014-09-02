//
//  NBLesson+Management.m
//  GM Calendar
//
//  Created by Nils Becker on 2/9/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBLesson+Management.h"
#import "NBClass+Management.h"

@implementation NBLesson (Management)

+ (NBLesson *)lessonFromDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context {
    NBLesson *newLesson = [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:context];
    
    newLesson.abbreviation = NULL_TO_NIL([args valueForKey:@"ap_name_short"]);
    newLesson.start = NULL_TO_NIL([args valueForKey:@"ap_time"]);
    newLesson.room = NULL_TO_NIL([args valueForKey:@"room"]);

    return newLesson;
}


- (BOOL)isPartOfLesson:(NBLesson *)lesson {
    return [self.abbreviation isEqualToString:lesson.abbreviation] && self.day == lesson.day && (([lesson.day intValue] - [self.day intValue]) > -1);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%d] - %@", self.start.intValue, self.name];
}

- (NSString *)name {
    return self.classForLesson.name;
}

@end
