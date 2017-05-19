//
//  BMPStationsTableView.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMPLoadStations.h"

@interface BMPStationsTableView : UITableViewController<LoaderDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BMPLoadStations *stationsLoader;

@end
