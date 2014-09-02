//
//  NBCourse+Management.h
//  GM Calendar
//
//  Created by Nils Becker on 2/25/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import "NBCourse.h"

@interface NBCourse (Management)

+ (NBCourse *)courseWithDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context;

@end
