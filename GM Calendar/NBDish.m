//
//  NBDish.m
//  GM Calendar
//
//  Created by Nils Becker on 21/12/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBDish.h"

@implementation NBDish

+ (instancetype)dishWithContentsOfDict:(NSDictionary *)dict
{
    NBDish *dish = [NBDish new];
    
    dish.name = [dict objectForKey:@"name"];
    dish.type = [dict objectForKey:@"type"];
    dish.price = [((NSNumber *)[dict objectForKey:@"price"]) floatValue];

    return dish;
}

@end
