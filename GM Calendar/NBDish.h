//
//  NBDish.h
//  GM Calendar
//
//  Created by Nils Becker on 21/12/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDish : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) float price;

+ (instancetype)dishWithContentsOfDict:(NSDictionary *)dict;

@end
