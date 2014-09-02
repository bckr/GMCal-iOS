//
//  NBCourseFetcher.m
//  GM Calendar
//
//  Created by Nils Becker on 2/14/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBCourseFetcher.h"
#import "NBLesson.h"
#import "NBLecturer.h"
#import "NBClass.h"
#import "NBLesson+Management.h"
#import "NBCourse.h"
#import "NBLecturer+Management.h"
#import "NBCourse+Management.h"
#import "NBClass+Management.h"

@interface NBCourseFetcher()

@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSMutableSet *courses;
@property int semester;

@end

@implementation NBCourseFetcher

#pragma mark Initializer

- (id)initWithMajor:(NSString *)major branch:(NSString *)branch semester:(int)semester {
    self = [super init];
    if (self) {
        self.major = major;
        self.branch = branch;
        self.semester = semester;
    }
    return self;
}

#pragma mark Public

- (void)fetchCourses {
    NSLog(@"Started fetching appointments");
    self.courses = [[NSMutableSet alloc] initWithCapacity:10];
#warning api currently not working!
    NSLog(@"%@", [NSString stringWithFormat:@"http://gmcal.nils-becker.com/cal/%@/%@/%d", _major, _branch, _semester]);
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://nils-becker.com/calendar/%@/%@/%d", _major, _branch, _semester]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.responseData = [[NSMutableData alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [connection start];
}

#pragma mark URLConnectionDownload delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"finished loading!");
    NSError *error;
    NSArray *jsonRep = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    
    NBLesson *lastLesson;
    
    [[self.managedObjectContext undoManager] beginUndoGrouping];
    [[self.managedObjectContext undoManager] setActionName:[NSString stringWithFormat:@"add action for semester: %d branch: %@ major: %@", self.semester, self.branch, self.major]];
    
    NSFetchRequest *lessonFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Lesson"];
    NSArray *lessonFetchResults = [self.managedObjectContext executeFetchRequest:lessonFetchRequest error:nil];
    NSMutableArray *lessonsToFilter = [[NSMutableArray alloc] initWithCapacity:15];

    for (NBLesson *existingLesson in lessonFetchResults) {
        [lessonsToFilter addObject:existingLesson.abbreviation];
    }
    
    NSMutableArray *lessonsToShow = [[NSMutableArray alloc] initWithCapacity:15];

    for (NSDictionary *dict in jsonRep) {
        NSString *abbreviation = NULL_TO_NIL([dict valueForKey:@"ap_name_short"]);
        if (![lessonsToFilter containsObject:abbreviation]) {
            [lessonsToShow addObject:dict];
        }
    }
    
    for (NSDictionary *dict in lessonsToShow) {
        static NBClass *currentClass;
        
        NBLesson *newLesson = [NBLesson lessonFromDict:dict inContext:self.managedObjectContext];
        NBLecturer *newLecturer = [NBLecturer lecturerFromDict:dict inContext:self.managedObjectContext];
        [newLesson addLecturerObject:newLecturer];
        
        // is the current lesson not part of the last lesson?
        if (!lastLesson || ![newLesson isPartOfLesson:lastLesson]) {
            currentClass = [NBClass classWithDict:dict inContext:self.managedObjectContext];
            [currentClass addLessonsObject:newLesson];
            
            NBCourse *newCourse = [NBCourse courseWithDict:dict inContext:self.managedObjectContext];
            [newCourse addClassesObject:currentClass];
            [self.courses addObject:newCourse];
        }
        // the current lesson is part of the last lesson
        else {
            // is this a new lecturer for the last lesson?
            if ([lastLesson.start isEqualToNumber:newLesson.start]  && [lastLesson.room isEqualToNumber:newLesson.room]) {
                [lastLesson addLecturer:newLesson.lecturer];
                // delete the redundant lesson and continue
                [self.managedObjectContext deleteObject:newLesson];
                continue;
            }
            // it is a new lesson for the current class
            else {
                [currentClass addLessonsObject:newLesson];
            }
        }
        lastLesson = newLesson;
    }
    
    [[self.managedObjectContext undoManager] endUndoGrouping];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.delegate respondsToSelector:@selector(courseFetcherDidLoadCourses:forBranch:inSemester:)]) {
        [self.delegate courseFetcherDidLoadCourses:[self.courses allObjects] forBranch:self.branch inSemester:self.semester];
    }
    
    self.courses = nil;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasFetchedAppointments"];
}

# pragma mark Error handling

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed with Error: %@", error.userInfo);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(courseFetcherDidFailWithError:)]) {
        [self.delegate courseFetcherDidFailWithError:error];
    }
}

#pragma mark Helper methods

- (NSMutableSet *)courses {
    if(!_courses) _courses = [[NSMutableSet alloc] initWithCapacity:10];
    return _courses;
}

@end

