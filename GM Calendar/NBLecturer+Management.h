//
//  NBLecturer+Management.h
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import "NBLecturer.h"

@interface NBLecturer (Management)

+ (NBLecturer *)lecturerFromDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context;

- (NSArray *)contactInfo;

@end
