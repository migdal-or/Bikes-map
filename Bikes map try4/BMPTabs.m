//
//  Tabs.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPTabs.h"
#import "BMPStationsMapView.h"
#import "BMPStationsTableView.h"
#import "BMPRidesHistoryView.h"

@interface BMPTabs ()

@property CLLocationManager * locationManager;

@end

@implementation BMPTabs

- (void)viewDidLoad {
    [super viewDidLoad];

    BMPStationsMapView * stationsMapView = [UIViewController new];// [BMPStationsMapView new];
//    stationsMapView.tabBarItem = [UITabBarItem new];
    stationsMapView.title = @"stations map";
//    stationsMapView
    
    BMPStationsTableView * tableView = [BMPStationsTableView new];
    tableView.title = @"stations table";
    
    BMPRidesHistoryView * ridesHistory = [BMPRidesHistoryView new];
    ridesHistory.title = @"velobike history";
    
    self.viewControllers = @[stationsMapView, tableView, ridesHistory];

//    [self.tabBar.items[0] setImage: [UIImage imageNamed:@"tabStations 150"]];
    
    _locationManager = [CLLocationManager new];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
