//
//  Schedule+RemoteJSONSerialization.m
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "Schedule+Remote.h"
#import "Lecture.h"

@implementation Schedule (Remote)

- (void)fetchRemoteSchedule{
    NSLog(@"Started fetching appointments");
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://nils-becker.com/calendar/%@/%@/%d", self.major, self.branch, self.semester]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestURL];
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
    NSDictionary *jsonRep = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    

    for (NSDictionary *dict in jsonRep) {
        Lecture *myLecture = [Lecture lectureWithContentsOfDict:dict];
        [self addLecture:myLecture];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSLog(@"%@", [self description]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed with Error: %@", error.userInfo);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
