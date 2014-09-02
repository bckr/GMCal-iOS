//
//  Appointment+Appointment_Factory.m
//  GM Calendar
//
//  Created by Nils Becker on 1/15/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "Appointment+Appointment_Factory.h"

@implementation Appointment (Appointment_Factory)

+ (Appointment *)AppointmentWithContentsOfDict:(NSDictionary *)args {
    Appointment *appointment = [self new];
    [appointment setValuesForKeysWithDictionary:args];
    return appointment;
}

@end
