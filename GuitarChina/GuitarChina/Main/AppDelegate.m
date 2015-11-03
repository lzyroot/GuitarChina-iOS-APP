//
//  AppDelegate.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "AppDelegate.h"
#import "GCNavigationController.h"
#import "GCHotThreadViewController.h"
#import "GCForumIndexViewController.h"
#import "GCMineViewController.h"
#import "GCSettingViewController.h"
#import "MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //集成友盟
    [MobClick startWithAppkey:@"5638ba4367e58ea3e9000b36" reportPolicy:BATCH channelId:@""];
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //日志加密
    [MobClick setEncryptEnabled:YES];
    //禁止后台模式
    [MobClick setBackgroundTaskEnabled:NO];
    
    //[self configureSideMenuViewController];
    //self.window.rootViewController = self.sideMenuViewController;
    
    //    [[GCNetworkManager manager] getProfileSuccess:^(GCHotThreadArray *array) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
        //        if ([cookie.name isEqualToString:@"7DUs_2132_saltkey"]) {
        //            [cookieJar deleteCookie:cookie];
        //            break;
        //        }
    }
    
    //    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    //    for (id obj in _tmpArray) {
    //        [cookieJar deleteCookie:obj];
    //    }
    
    [self configureTabBarController];
    
    self.rightMenuViewController = [[GCThreadRightMenuViewController alloc] init];

    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.tabBarController
                                                             leftMenuViewController:nil
                                                            rightMenuViewController:self.rightMenuViewController];
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1;
    self.sideMenuViewController.delegate = self;
    self.sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0;
    self.sideMenuViewController.contentViewShadowRadius = 5;
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.contentViewScaleValue = 1;
    self.sideMenuViewController.contentViewBorderEnabled = YES;
    self.sideMenuViewController.contentViewBorderPosition = ContentViewBorderPositionLeftAndRight;
    self.sideMenuViewController.contentViewBorderWidth = 0.5;
    self.sideMenuViewController.contentViewBorderColor = [UIColor lightGrayColor].CGColor;
    self.sideMenuViewController.scaleMenuView = NO;
    self.sideMenuViewController.fadeMenuView = NO;
    self.sideMenuViewController.panGestureEnabled = NO;
    if (DeviceiPhone) {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = ScreenWidth * 0.166;
    } else {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = LeftSideMenuOffsetCenterXIniPad;
    }

    
    
    
    self.window.rootViewController = self.sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveCookie];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveCookie];
    [self saveContext];
}

#pragma mark - RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "GuitarChina.GuitarChina" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GuitarChina" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GuitarChina.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *nCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookiesURL = [nCookies cookiesForURL:[NSURL URLWithString:@"http://bbs.guitarchina.com/"]];
    
    for (id c in cookiesURL)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12]; //当前点后，保存一年左右
            NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, expiresDate, cookie.domain, cookie.path, nil];
            
            if(cookies){
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
                [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
                [cookieProperties setObject:[cookies objectAtIndex:2] forKey:NSHTTPCookieExpires];
                [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
                
                NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
            }
        }
    }
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Private Methods

- (void)configureSideMenuViewController {
    GCHotThreadViewController *hotThreadViewController = [[GCHotThreadViewController alloc] init];
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:hotThreadViewController];
    self.leftMenuViewController = [[GCLeftMenuViewController alloc] init];
    self.rightMenuViewController = [[GCThreadRightMenuViewController alloc] init];
    [self.leftMenuViewController configureFirstViewController:hotThreadViewController];
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                             leftMenuViewController:nil
                                                            rightMenuViewController:self.rightMenuViewController];
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1;
    self.sideMenuViewController.delegate = self;
    self.sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0;
    self.sideMenuViewController.contentViewShadowRadius = 5;
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.contentViewScaleValue = 1;
    self.sideMenuViewController.contentViewBorderEnabled = YES;
    self.sideMenuViewController.contentViewBorderPosition = ContentViewBorderPositionLeftAndRight;
    self.sideMenuViewController.contentViewBorderWidth = 0.5;
    self.sideMenuViewController.contentViewBorderColor = [UIColor lightGrayColor].CGColor;
    self.sideMenuViewController.scaleMenuView = NO;
    self.sideMenuViewController.fadeMenuView = NO;
    if (DeviceiPhone) {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = 200;
    } else {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = LeftSideMenuOffsetCenterXIniPad;
    }
}

- (void)configureTabBarController {
    self.tabBarController = [[GCTabBarController alloc]init];
    
    GCHotThreadViewController *hotThreadViewController = [[GCHotThreadViewController alloc] init];
    GCNavigationController *hotThreadNavigationController = [[GCNavigationController alloc] initWithRootViewController:hotThreadViewController];
    hotThreadNavigationController.tabBarItem.title = NSLocalizedString(@"Hot", nil);
    hotThreadNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_hot"];
    hotThreadNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_hot_on"];
    
    GCForumIndexViewController *forumIndexViewController = [[GCForumIndexViewController alloc] init];
    GCNavigationController *forumIndexNavigationController = [[GCNavigationController alloc] initWithRootViewController:forumIndexViewController];
    forumIndexNavigationController.tabBarItem.title = NSLocalizedString(@"Forum", nil);
    forumIndexNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_forum"];
    forumIndexNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_forum_on"];
    
    GCMineViewController *mineViewController = [[GCMineViewController alloc] init];
    GCNavigationController *mineNavigationController = [[GCNavigationController alloc] initWithRootViewController:mineViewController];
    mineNavigationController.tabBarItem.title = NSLocalizedString(@"Mine", nil);
    mineNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_mine"];
    mineNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_mine_on"];
    
    GCSettingViewController *settingViewController = [[GCSettingViewController alloc] init];
    GCNavigationController *settingNavigationController = [[GCNavigationController alloc] initWithRootViewController:settingViewController];
    settingNavigationController.tabBarItem.title = NSLocalizedString(@"Setting", nil);
    settingNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_setting"];
    settingNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_setting_on"];
    
    self.tabBarController.viewControllers = @[hotThreadNavigationController, forumIndexNavigationController, mineNavigationController, settingNavigationController];
}

@end
