//
//  NBNewsItem+Management.h
//  GM Calendar
//
//  Created by Nils Becker on 2/23/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsItem.h"

@interface NBNewsItem (Management)

+ (NBNewsItem *)newsItemWithContext:(NSManagedObjectContext *)context andGuid:(NSString *)guid;

@end
