//
//  BMPTableViewCell.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 16/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *Id;
@property(nonatomic, strong) UILabel *Address;
@property(nonatomic, strong) UILabel *longText;
@property(nonatomic, strong) UIImage *electric;

- (void)fillCellWithData:(NSDictionary *)station;

@end
