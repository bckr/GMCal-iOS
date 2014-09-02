//
//  NBCourse.h
//  GM Calendar
//
//  Created by Nils Becker on 2/13/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBClass;

@interface NBCourse : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSSet *classes;
@end

@interface NBCourse (CoreDataGeneratedAccessors)

- (void)addClassesObject:(NBClass *)value;
- (void)removeClassesObject:(NBClass *)value;
- (void)addClasses:(NSSet *)values;
- (void)removeClasses:(NSSet *)values;

@end
