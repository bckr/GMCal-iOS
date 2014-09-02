//
//  NBNewsItem+Management.m
//  GM Calendar
//
//  Created by Nils Becker on 2/23/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsItem+Management.h"

@implementation NBNewsItem (Management)

+ (NBNewsItem *)newsItemWithContext:(NSManagedObjectContext *)context andGuid:(NSString *)guid {
    NSFetchRequest *newsItemFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
    NSError *error;
    NSArray *newsItems = [context executeFetchRequest:newsItemFetchRequest error:&error];
    
    if (!newsItems) {
        NSLog(@"Unresolved Error: %@", [error localizedDescription]);
    }
    
    
    // check if news item allready exists
    if ([newsItems count] > 0) {
        for (NBNewsItem *existingItem in newsItems) {
            if ([existingItem.guid isEqualToString:guid])
                return existingItem;
        }
    }
    
    NBNewsItem *newNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:context];
    return newNewsItem;
    
}

@end
