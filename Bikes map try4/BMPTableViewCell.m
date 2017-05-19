//
//  BMPTableViewCell.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 16/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPTableViewCell.h"

@implementation BMPTableViewCell

static UIImage *electricBikeIcon, *regularBikeIcon;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    self = [super init];
    if (!electricBikeIcon) {
        electricBikeIcon = [UIImage imageNamed:@"electric"];
    }
    if (!regularBikeIcon) {
        regularBikeIcon = [UIImage imageNamed:@"regular"];
    }
    return self;
}

- (void)fillCellWithData:(NSDictionary *)station {
    if (station) {
        _Id = station[@"Id"];
        _Address = station[@"Address"];
        _longText = station[@"Id"];
//        _electric = ? station[@"StationTypes"];

    };
}

@end
