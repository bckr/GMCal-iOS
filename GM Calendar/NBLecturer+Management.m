//
//  NBLecturer+Management.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBLecturer+Management.h"
#import "NSString+Extensions.h"

@implementation NBLecturer (Management)

+ (NBLecturer *)lecturerFromDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Lecturer"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"abbreviation = %@", NULL_TO_NIL([args valueForKey:@"lecturer_short"])];
    fetchRequest.fetchLimit = 1;

    NBLecturer *existingLecturer = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    
    // check if lecturer allready exists
    if (existingLecturer) {
        return existingLecturer;
    }
    
    NBLecturer *newLecturer = [NSEntityDescription insertNewObjectForEntityForName:@"Lecturer" inManagedObjectContext:context];
    newLecturer.abbreviation = NULL_TO_NIL([args valueForKey:@"lecturer_short"]);
    newLecturer.forename = NULL_TO_NIL([args valueForKey:@"lecturer_first"]);
    newLecturer.surname = NULL_TO_NIL([args valueForKey:@"lecturer_last"]);
    
    return newLecturer;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.forename, self.surname];
}

- (NSArray *)contactInfo {
    NSMutableArray *info = [[NSMutableArray alloc] initWithCapacity:5];

    if (self.title && !self.title.isEmpty) [info addObject:@{@"Titel" : self.title}];
    if (self.function && !self.function.isEmpty) [info addObject:@{@"Funktion" : self.function}];
    if (self.branch) {
        NSString *branch = self.branch.intValue == 19 ? @"Ingenieurwesen" : @"Informatik";
        [info addObject:@{@"Bereich" : branch}];
    }
    if (self.email  && !self.email.isEmpty) [info addObject:@{@"Mail" : self.email}];
    if (self.homepage && !self.homepage.isEmpty) [info addObject:@{@"Web" : self.homepage}];
    if (self.phone  && !self.phone.isEmpty) [info addObject:@{@"Tel" : self.phone}];
    
    return [NSArray arrayWithArray:info];
}

@end