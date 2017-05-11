//
//  AppDelegate.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "AppDelegate.h"
#import "BMPTabs.h"
#import "BMPStationsMapView.h"
#import "BMPStationsTableView.h"
#import "BMPRidesHistoryView.h"
#import <CoreLocation/CLLocationManager.h>

@interface AppDelegate ()

@property CLLocationManager * locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    BMPStationsMapView * stationsMapView = [BMPStationsMapView new];
    //    stationsMapView.tabBarItem = [UITabBarItem new];
    stationsMapView.title = @"stations map";
    //    stationsMapView
    
    BMPStationsTableView * tableView = [BMPStationsTableView new];
    tableView.title = @"stations table";
    
    BMPRidesHistoryView * ridesHistory = [BMPRidesHistoryView new];
    ridesHistory.title = @"velobike history";
    
    //    [self.tabBar.items[0] setImage: [UIImage imageNamed:@"tabStations 150"]];
    
    _locationManager = [CLLocationManager new];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }

    
    BMPTabs *vc = [BMPTabs new];
    
    vc.viewControllers = @[stationsMapView, tableView, ridesHistory];
    
    window.rootViewController = vc;
    self.window = window;
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
