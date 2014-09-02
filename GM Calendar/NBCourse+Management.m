//
//  NBCourse+Management.m
//  GM Calendar
//
//  Created by Nils Becker on 2/25/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBCourse+Management.h"

@implementation NBCourse (Management)

+ (NBCourse *)courseWithDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    // unique key is name -- not abbreviation!
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", NULL_TO_NIL([args valueForKey:@"ap_name_long"])];
    fetchRequest.fetchLimit = 1;

    NBCourse *existingCourse = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    
    if (existingCourse) {
        return existingCourse;
    }
    
    NBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    newCourse.name = NULL_TO_NIL([args valueForKey:@"ap_name_long"]);
    newCourse.abbreviation = NULL_TO_NIL([args valueForKey:@"ap_name_short"]);

    return newCourse;
}

@end
