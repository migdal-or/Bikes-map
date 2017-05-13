//
//  BMPAnnotation.h
//  Bikes map try4
//
//  Created by Admin on 11/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMPAnnotation : NSObject<MKAnnotation>

//-(id)initWithTitle:(NSString*)newTitle subtitle:(NSString *)subTitle location:(CLLocationCoordinate2D)location;
//-(MKAnnotationView *)annotationView;
-(id)initWithDict:(NSDictionary *)parameters;

@end
