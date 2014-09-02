//
//  NBLecturer.h
//  GM Calendar
//
//  Created by Nils Becker on 2/9/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBLesson;

@interface NBLecturer : NSManagedObject

@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSNumber * branch;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * forename;
@property (nonatomic, retain) NSString * form;
@property (nonatomic, retain) NSString * function;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * room;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *lessons;
@end

@interface NBLecturer (CoreDataGeneratedAccessors)

- (void)addLessonsObject:(NBLesson *)value;
- (void)removeLessonsObject:(NBLesson *)value;
- (void)addLessons:(NSSet *)values;
- (void)removeLessons:(NSSet *)values;

@end
