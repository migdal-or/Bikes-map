//
//  BMPAnnotation.m
//  Bikes map try4
//
//  Created by Admin on 11/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BMPAnnotation.h"
#import <MapKit/MapKit.h>

@interface BMPAnnotation () <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate; //+readwrite не писать
@property (nonatomic, copy) NSString *title;    //+внутри не надо копи, можно strong
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation BMPAnnotation

-(id)initWithDict:(NSDictionary *)parameters {
    if (self) {
        if ([@"true" isEqualToString:[parameters valueForKey:@"IsLocked"]]) return nil; //+ обращение к словарям через [], no valueforkey
        
        NSString *is_electric, *stationNumber, *temp;

        CLLocationCoordinate2D coordinate;
        coordinate.latitude  = [[[parameters valueForKey:@"Position"] valueForKey:@"Lat"] doubleValue]; //+ []
        coordinate.longitude = [[[parameters valueForKey:@"Position"] valueForKey:@"Lon"] doubleValue];
        
        stationNumber = [parameters valueForKey:@"Id"]; //proven best techique to get rid of leading 0s
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
        is_electric = ((0==[parameters valueForKey:@"TotalElectricPlaces"])?@"Электрическая":@"Механическая");

        unsigned int total_places = [[parameters valueForKey:@"TotalPlaces"] doubleValue];
        unsigned int free_places = [[parameters valueForKey:@"FreePlaces"] doubleValue];
        NSString * address = [parameters valueForKey:@"Address"];
        
        _subtitle = [NSString stringWithFormat:@"%@. %@.\n%u мест. Свободных %u", address, is_electric, total_places, free_places];
        temp = [NSString stringWithFormat:@"^(%03d - )*", [stationNumber integerValue]];
        NSRange range = [_subtitle rangeOfString:temp options:NSRegularExpressionSearch];
        _subtitle = [_subtitle stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return self;
}
@end
