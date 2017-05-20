//
//  BMPTableViewCell.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 16/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPTableViewCell : UITableViewCell

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *Address;
@property(nonatomic, strong) NSString *longText;
@property(nonatomic, assign) BOOL electric;

- (void)fillCellWithData:(NSDictionary *)station;

@end
