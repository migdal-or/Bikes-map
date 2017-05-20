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
static CGFloat const IdFontSize = 14;
static CGFloat const addressFontSize = 14;
static CGFloat const textFontSize = 14;

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

        UILabel *idLabel = [UILabel new];
        idLabel.frame = CGRectMake(50, 0, 3, 3);
        [idLabel setFont:[UIFont boldSystemFontOfSize:IdFontSize]];
        idLabel.text = _Id;
        [idLabel sizeToFit];
        [self addSubview:idLabel];
        
        UILabel *addressLabel = [UILabel new];
        addressLabel.frame = CGRectMake(50, 30, 3, 3);
        [addressLabel setFont:[UIFont boldSystemFontOfSize:addressFontSize]];
        addressLabel.text = _Address;
        [addressLabel sizeToFit];
        [self addSubview:addressLabel];
        
        UILabel *textLabel = [UILabel new];
        textLabel.frame = CGRectMake(50, 60, 3, 3);
        [textLabel setFont:[UIFont boldSystemFontOfSize:textFontSize]];
        textLabel.text = _longText;
        [textLabel sizeToFit];
        [self addSubview:textLabel];
        
        _electric = (0 == station[@"TotalElectricPlaces"]) ? NO : YES;
        UIImageView *is_electric = [[UIImageView alloc] initWithImage: _electric ? electricBikeIcon : regularBikeIcon];
        is_electric.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:is_electric];
    };
}

@end
