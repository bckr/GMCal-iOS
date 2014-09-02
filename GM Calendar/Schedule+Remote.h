//
//  Schedule+RemoteJSONSerialization.h
//  GM Calendar
//
//  Created by Nils Becker on 10/22/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "NBSchedule.h"

@interface NBSchedule (Remote) <NSURLConnectionDataDelegate>

- (void)fetchRemoteSchedule;

@end
