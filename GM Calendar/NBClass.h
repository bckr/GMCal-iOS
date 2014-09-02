//
//  NBClass.h
//  GM Calendar
//
//  Created by Nils Becker on 2/17/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBCourse, NBLesson;

@interface NBClass : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * start;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NBCourse *course;
@property (nonatomic, retain) NSSet *lessons;
@end

@interface NBClass (CoreDataGeneratedAccessors)

- (void)addLessonsObject:(NBLesson *)value;
- (void)removeLessonsObject:(NBLesson *)value;
- (void)addLessons:(NSSet *)values;
- (void)removeLessons:(NSSet *)values;

@end
