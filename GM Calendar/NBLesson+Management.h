//
//  NBLesson+Management.h
//  GM Calendar
//
//  Created by Nils Becker on 2/9/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import "NBLesson.h"

@interface NBLesson (Management)

+ (NBLesson *)lessonFromDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context;

- (BOOL)isPartOfLesson:(NBLesson *)lesson;
- (NSString *)name;

@end
