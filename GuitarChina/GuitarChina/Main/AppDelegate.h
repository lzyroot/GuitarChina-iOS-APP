//
//  AppDelegate.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESideMenu.h"
#import "GCLeftMenuViewController.h"
#import "GCThreadRightMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) GCLeftMenuViewController *leftMenuViewController;
@property (strong, nonatomic) GCThreadRightMenuViewController *rightMenuViewController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
