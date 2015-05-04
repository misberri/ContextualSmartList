//
//  MISGeoSmartAppDelegate.m
//  GeoSmart
//
//  Created by Agathe Battestini on 5/1/15.
//  Copyright (c) 2015 Misberri. All rights reserved.
//


#import "MISGeoSmartAppDelegate.h"
#import "MISSmartListViewController.h"
#import "MISLogFormatter.h"
#import "MISSmartListViewModel.h"
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>
#import "PTEDashboard.h"
#import "MISSmartManager.h"

@interface MISGeoSmartAppDelegate ()
{
    DDFileLogger *_fileLogger;
    MISLogFormatter *_logFormatter;
}

@end

@implementation MISGeoSmartAppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupLoggers];
    [PTEDashboard.sharedDashboard show];


    // setup the main app UI
    [self setupNavigationController];




    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UI utils

- (void)setupNavigationController {
    MISSmartListViewModel *viewModel = [[MISSmartListViewModel alloc] init];
    MISSmartListViewController *listViewController = [[MISSmartListViewController alloc] initWithViewModel:viewModel];
    UINavigationController *navigationController = [[UINavigationController alloc]
            initWithRootViewController:listViewController];
    self.window.rootViewController = navigationController;
}

#pragma mark - Utils

- (void)setupLoggers{
    _logFormatter = [MISLogFormatter new];

    [[DDASLLogger sharedInstance] setLogFormatter:_logFormatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:_logFormatter];

    [DDLog addLogger:[DDASLLogger sharedInstance]]; // logs on the console app
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // logs on the Xcode console app

    // define where to put the log files
    NSURL *documentUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString * applicationDocumentsDirectory = [documentUrl path];
    DDLogInfo(@"Application document folder %@", applicationDocumentsDirectory);
    DDLogFileManagerDefault *documentsFileManager = [[DDLogFileManagerDefault alloc]
            initWithLogsDirectory:applicationDocumentsDirectory];

    // FIXME probably for release only
    _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:documentsFileManager];
    _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [_fileLogger setLogFormatter:_logFormatter];
    [DDLog addLogger:_fileLogger];

    // Adding the NSLogger logger
    //    [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];

    DDLogVerbose(@"DDLog loggers setup OK-Verbose: %@", [DDLog allLoggers]);
    DDLogError(@"DDLog loggers setup OK-Error: %@", [DDLog allLoggers]);
    // Levels: see https://github.com/CocoaLumberjack/CocoaLumberjack/wiki/GettingStarted
    // Error, Warn, Info, Debug, Verbose

}

@end