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

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;

@end

@implementation BMPAnnotation

//-(id)initWithTitle:(NSString *)newTitle subtitle:(NSString *)subTitle location:(CLLocationCoordinate2D)location {
//    if (self) {
//        _title = newTitle;
//        _coordinate = location;
//        _subtitle = subTitle;
//    }
//    
//    return self;
//}

-(id)initWithDict:(NSDictionary *)parameters {
    if (self) {
        NSString * is_electric;

        CLLocationCoordinate2D coordinate;
        coordinate.latitude  = [[[parameters valueForKey:@"Position"] valueForKey:@"Lat"] doubleValue];
        coordinate.longitude = [[[parameters valueForKey:@"Position"] valueForKey:@"Lon"] doubleValue];
        _title = [parameters valueForKey:@"Id"];
        _coordinate = coordinate;
        is_electric = ((0==[parameters valueForKey:@"TotalElectricPlaces"])?@"Механические":@"Электрические");

        unsigned int total_places = [[parameters valueForKey:@"TotalPlaces"] doubleValue];
        unsigned int free_places = [[parameters valueForKey:@"FreePlaces"] doubleValue];
        NSString * address = [parameters valueForKey:@"Address"];
        _subtitle = [NSString stringWithFormat:@"%@\n%@\nВсего мест: %u\nСвободных мест:%u", address, is_electric, total_places, free_places];
    }
    
    return self;
}


//-(MKAnnotationView *)annotationView {
//    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"bike-station"];
//    annotationView.enabled = YES;
//    annotationView.canShowCallout = YES;
//    annotationView.image = [UIImage imageNamed:@"station icon 18"];
//    return annotationView;
//}

@end
