//
//  NBClass+Management.h
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import "NBClass.h"

@interface NBClass (Management)

+ (NBClass *)classWithDict:(NSDictionary *)args inContext:(NSManagedObjectContext *)context;

- (int)endOfClass;
- (NSSet *)lecturers;
- (NSArray *)sortedLessons;
- (NSString *)typeString;
- (NSString *)name;
- (NSString *)abbreviation;

@end
