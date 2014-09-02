//
//  Lecture.h
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lecture : NSObject

@property (nonatomic, strong) NSString *ap_name_short;
@property (nonatomic, strong) NSString *ap_name_long;
@property (nonatomic, strong) NSString *ap_day;
@property (nonatomic, strong) NSString *ap_time;
@property (nonatomic, strong) NSString *ap_type;

@property (nonatomic, strong) NSString *room;

@property (nonatomic, strong) NSString *lecturer_short;
@property (nonatomic, strong) NSString *lecturer_first;
@property (nonatomic, strong) NSString *lecturer_last;

+ (Lecture *)lectureWithContentsOfDict:(NSDictionary *)args;

@end
