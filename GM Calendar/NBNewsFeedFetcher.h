//
//  NBNewsFeedParser.h
//  GM Calendar
//
//  Created by Nils Becker on 2/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNewsFeedFetcher : NSObject <NSXMLParserDelegate>

- (id)initWithNewsFeedURL:(NSURL *)feedURL;
- (void)fetch;

@end