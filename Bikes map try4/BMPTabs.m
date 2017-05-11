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

@end

@implementation BMPTabs

- (void)viewDidLoad {
    [super viewDidLoad];

    BMPStationsMapView * stationsMapView = [BMPStationsMapView new];
//    stationsMapView.tabBarItem = [UITabBarItem new];
    stationsMapView.title = @"stations map";
    
    BMPStationsTableView * tableView = [BMPStationsTableView new];
    tableView.title = @"stations table";
    
    BMPRidesHistoryView * ridesHistory = [BMPRidesHistoryView new];
    ridesHistory.title = @"velobike history";
    
    self.viewControllers = @[stationsMapView, tableView, ridesHistory];

    CLLocationManager *locationManager = [CLLocationManager new];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
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
