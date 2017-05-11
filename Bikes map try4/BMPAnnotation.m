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
@property (nonatomic, readwrite, copy, nullable) NSString *title;
@property (nonatomic, readwrite, copy, nullable) NSString *subtitle;

@end

@implementation BMPAnnotation

-(id)initWithTitle:(NSString *)newTitle subtitle:(NSString *)subTitle location:(CLLocationCoordinate2D)location {
//    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
        _subtitle = subTitle;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"bike-station"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"bike-station"];
    return annotationView;
}

@end
