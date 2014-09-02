//
//  NBCourseFetcher.h
//  GM Calendar
//
//  Created by Nils Becker on 2/14/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import <Foundation/Foundation.h>

@protocol NBCourseFetcherDelegate <NSObject>

@optional
- (void)courseFetcherDidLoadCourses:(NSArray *)courses forBranch:(NSString *)branch inSemester:(NSUInteger)semester;
- (void)courseFetcherDidFailWithError:(NSError *)error;

@end

@interface NBCourseFetcher : NSObject <NSURLConnectionDataDelegate>

@property (weak) id<NBCourseFetcherDelegate> delegate;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)initWithMajor:(NSString *)major branch:(NSString *)branch semester:(int)semester;

- (void)fetchCourses;

@end
