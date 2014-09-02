//
//  Appointment+Appointment_Factory.h
//  GM Calendar
//
//  Created by Nils Becker on 1/15/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "Appointment.h"

@interface Appointment (Appointment_Factory)

+ (Appointment *)AppointmentWithContentsOfDict:(NSDictionary *)args;

@end
