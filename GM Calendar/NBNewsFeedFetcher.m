//
//  NBNewsFeedParser.m
//  GM Calendar
//
//  Created by Nils Becker on 2/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsFeedFetcher.h"
#import "AppDelegate.h"
#import "NBNewsItem+Management.h"
#import "NSString+Extensions.h"

@interface NBNewsFeedFetcher ()

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, strong) NSXMLParser *newsParser;
@property (nonatomic, strong) NSURL *feedURL;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NBNewsItem *currentNewsItem;
@property BOOL append;
@property BOOL isFetching;

@end

@implementation NBNewsFeedFetcher

#pragma mark Initializer

- (id)initWithNewsFeedURL:(NSURL *)feedURL {
    self = [super init];
    if (self) {
        self.feedURL = feedURL;
        self.append = NO;
    }
    return self;
}

#pragma Fetch Preparation

- (void)fetch {
    if (!self.isFetching) {
        self.isFetching = YES;
        self.responseData = [[NSMutableData alloc] init];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.feedURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
        
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [conn start];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.newsParser = [[NSXMLParser alloc] initWithData:self.responseData];
    self.newsParser.delegate = self;
    [self.newsParser parse];
}

#pragma mark XML Parser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.append = YES;
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.append) {
        if ([self.currentElement isEqualToString:@"guid"]) {
            NSFetchRequest *newsItemFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
            newsItemFetchRequest.predicate = [NSPredicate predicateWithFormat:@"guid = %@", string];
            NSError *error;
            NSArray *newsItems = [self.managedObjectContext executeFetchRequest:newsItemFetchRequest error:&error];
            if ([newsItems count] != 0) {
                return;
            } else if (![[string pathExtension] isEqualToString:@""]) {
                self.currentNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:self.managedObjectContext];
                self.currentNewsItem.guid = string;
            } else {
                //            NSLog(@"link has no path extension");
            }
        } else if ([self.elementsOfInterest containsObject:self.currentElement] && self.currentElement) {
            NSString *currentValue = [self.currentNewsItem valueForKey:self.currentElement];
            NSString *newValue;
            if (currentValue) {
                newValue = [currentValue stringByAppendingString:string];
            } else {
                newValue = string;
            }
            [self.currentNewsItem setValue:newValue forKey:self.currentElement];
        } else if ([self.currentElement isEqualToString:@"pubDate"] && self.currentElement) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [dateFormatter setDateFormat:@"EEE, d MMMM yyyy HH:mm:ss Z"];
            NSDate *date = [dateFormatter dateFromString:string];
            self.currentNewsItem.date = date;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if ([self.currentElement isEqualToString:@"description"] && self.currentNewsItem && self.append) {
        self.currentNewsItem.content = CDATABlock;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.append = NO;
}

- (NSArray *)elementsOfInterest {
    return @[@"title", @"link", @"author", @"category"];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parser ended parsing document");
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved Error %@", [error localizedDescription]);
    }
    self.responseData = nil;
    self.currentNewsItem = nil;
    self.currentElement = nil;
    self.append = NO;
    self.isFetching = NO;
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"fetchedNews" object:nil]];
}

#pragma Core Data

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _managedObjectContext;
}


@end
