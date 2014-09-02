//
//  NBLesson.h
//  GM Calendar
//
//  Created by Nils Becker on 2/19/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBClass, NBLecturer;

@interface NBLesson : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * room;
@property (nonatomic, retain) NSNumber * start;
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NBClass *classForLesson;
@property (nonatomic, retain) NSSet *lecturer;
@end

@interface NBLesson (CoreDataGeneratedAccessors)

- (void)addLecturerObject:(NBLecturer *)value;
- (void)removeLecturerObject:(NBLecturer *)value;
- (void)addLecturer:(NSSet *)values;
- (void)removeLecturer:(NSSet *)values;

@end
