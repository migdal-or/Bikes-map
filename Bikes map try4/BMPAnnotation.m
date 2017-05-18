//
//  BMPAnnotation.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 11/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPAnnotation.h"
#import <MapKit/MapKit.h>

@interface BMPAnnotation () <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, nullable) NSString *title;
@property (nonatomic, nullable) NSString *subtitle;

@end

@implementation BMPAnnotation

- (instancetype)initWithDictionary:(NSDictionary *)parameters {
    if (self) {
        if ([@"true" isEqualToString:parameters[@"IsLocked"]]) return nil; // если станция заблокирована - не надо её рисовать
        
        NSString *is_electric, *stationNumber, *temp;

        CLLocationCoordinate2D coordinate;
        coordinate.latitude  = [parameters[@"Position"][@"Lat"] doubleValue];
        coordinate.longitude = [parameters[@"Position"][@"Lon"] doubleValue];
        
        stationNumber = parameters[@"Id"]; //proven best techique to get rid of leading 0s
        // on http://stackoverflow.com/questions/13354933/nsstring-remove-leading-0s-so-00001234-becomes-1234
        for (NSUInteger i = 0; i < [stationNumber length]; i++) {
            if ([stationNumber characterAtIndex:i] != '0') {
                temp = [stationNumber substringFromIndex:i];
                break;
            }
        }
        stationNumber = temp;
        _title = [NSString stringWithFormat:@"Станция №%@", stationNumber];
        
        _coordinate = coordinate;
        is_electric = ((0==parameters[@"TotalElectricPlaces"])?@"Электрическая":@"Механическая");

        unsigned int total_places = [parameters[@"TotalPlaces"] doubleValue];
        unsigned int free_places = [parameters[@"FreePlaces"] doubleValue];
        NSString *address = parameters[@"Address"];
        
        _subtitle = [NSString stringWithFormat:@"%@. %@.\n%u мест. Свободных %u", address, is_electric, total_places, free_places];
        temp = [NSString stringWithFormat:@"^(%03d - )*", [stationNumber integerValue]];
        NSRange range = [_subtitle rangeOfString:temp options:NSRegularExpressionSearch];
        _subtitle = [_subtitle stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return self;
}
@end
