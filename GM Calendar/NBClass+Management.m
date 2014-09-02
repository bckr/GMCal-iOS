//
//  NBClass+Management.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBClass+Management.h"
#import "NBLesson.h"
#import "NBCourse.h"
#import "NBLecturer.h"

@implementation NBClass (Management)

+ (NBClass *)classWithDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context {
    NBClass *newClass = [NSEntityDescription insertNewObjectForEntityForName:@"Class" inManagedObjectContext:context];
    newClass.day = NULL_TO_NIL([args valueForKey:@"ap_day"]);
    newClass.type = NULL_TO_NIL([args valueForKey:@"ap_type"]);
    newClass.start = NULL_TO_NIL([args valueForKey:@"ap_time"]);

    return newClass;
}

- (int)endOfClass {
    return [[[self lastLesson] start] intValue] + 1;
}

- (NSSet *)lecturers {
    NSMutableSet *lecturers = [[NSMutableSet alloc] initWithCapacity:3];
    for (NBLesson *lesson in self.lessons.allObjects) {
        [lecturers addObjectsFromArray:lesson.lecturer.allObjects];
    }
    return lecturers;
}

- (NSArray *)sortedLessons {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES];
    return [self.lessons sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NBLesson *)lastLesson {
    return [[self sortedLessons] lastObject];
}

- (NSString *)typeString {
    NSDictionary *types = @{@"V" : @"Vorlesung", @"P" : @"Praktikum", @"S" : @"Seminar", @"UE" :  @"Übung", @"T" :  @"Tutorium"};
    return [types valueForKey:self.type];
}

- (NSString *)name {
    return self.course.name;
}

- (NSString *)abbreviation {
    return self.course.abbreviation;
}

@end
