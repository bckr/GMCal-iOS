//
//  NBAppSettingsTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/13/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBAppSettingsTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface NBAppSettingsTableViewController ()

@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation NBAppSettingsTableViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Einstellungen";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
        [self.mailComposeViewController setSubject:@"♥"];
        [self.mailComposeViewController setToRecipients:@[@"hi@nils-becker.com"]];
        [self.mailComposeViewController setTitle:@"Feedback senden"];
        self.mailComposeViewController.mailComposeDelegate = self;
        [self presentViewController:self.mailComposeViewController animated:YES completion:^{
            NSLog(@"Mail Compose View presented");
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.mailComposeViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Mail Compose View dismissed");
    }];
}

@end
