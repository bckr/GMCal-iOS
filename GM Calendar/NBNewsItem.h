//
//  NBNewsItem.h
//  GM Calendar
//
//  Created by Nils Becker on 2/27/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NBNewsItem : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * title;

@end
