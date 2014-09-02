//
//  AppDelegate.h
//  GM Calendar
//
//  Created by Nils Becker on 10/21/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController, TVNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
