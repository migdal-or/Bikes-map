//
//  BMPStationsTableView.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPStationsTableView.h"
#import "BMPTableViewCell.h"

static CGFloat const TOOFAR_LABEL_HEIGHT = 60;

@interface BMPStationsTableView ()

@property (nonatomic, strong) UILabel *labelOnTopOfMap;
@property (nonatomic, assign) BOOL locationWasObtained;
@property (nonatomic, strong) NSArray<NSDictionary *> *parkings;

@end

@implementation BMPStationsTableView

static NSString const *cellReuseIdentifier = @"cellReuseIdentifier";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createView];
    
    [self loadStations];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)didLoadStations:(NSDictionary *) parkings {
    // is being called when async download of stations finishes
    // so we can continue
    _stationsLoader.delegate = nil;
    
    _parkings = parkings[@"Items"];
    if (DEBUG) { NSLog(@"init %d stations done", [_parkings count]); }
    
    _labelOnTopOfMap.hidden = YES;
    
    [self.tableView reloadData];
}

- (void)loadStations {
    // start getting stations from api or local file
    _labelOnTopOfMap.text = @"Loading stations,\nplease wait";
    _labelOnTopOfMap.textColor = [UIColor blackColor];
    _labelOnTopOfMap.hidden = NO;
    
    // делегирование лоадеру и ожидание асинхронной загрузки
    _stationsLoader.delegate = self;
    [_stationsLoader loadStations];
}

- (void)createView {
    //столько надо отступить снизу чтобы не прятать данные под таббаром
    self.tableView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height);
    
    // add a label to show misc information
    _labelOnTopOfMap = [UILabel new];
    _labelOnTopOfMap.font = [UIFont boldSystemFontOfSize:18.0];
    _labelOnTopOfMap.textAlignment = NSTextAlignmentCenter;
    _labelOnTopOfMap.hidden = YES;
    _labelOnTopOfMap.lineBreakMode = NSLineBreakByWordWrapping;
    _labelOnTopOfMap.numberOfLines = 0;
    _labelOnTopOfMap.frame = CGRectMake(0, (self.view.bounds.size.height-TOOFAR_LABEL_HEIGHT)/2, self.view.bounds.size.width, TOOFAR_LABEL_HEIGHT);
    [self.view addSubview:_labelOnTopOfMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (DEBUG) { NSLog(@"init %d items", _parkings.count); };
    return [_parkings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[BMPTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    BMPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [cell fillCellWithData:(NSDictionary *)_parkings[indexPath.row]];

    //    [cell layer].borderWidth = 1.0f;
    
    return cell;
}

@end
