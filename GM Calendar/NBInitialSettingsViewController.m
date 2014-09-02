//
//  NBInitialSettingsViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 3/2/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsViewController.h"

@interface NBInitialSettingsViewController ()

@end

@implementation NBInitialSettingsViewController

- (void)viewDidAppear:(BOOL)animated {
    [NSThread sleepForTimeInterval:0.5];
    [self performSegueWithIdentifier:@"showInitialSettingsSegue" sender:self];
}

@end
