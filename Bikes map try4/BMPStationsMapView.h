//
//  ViewController.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMPLoadStations.h"

@interface BMPStationsMapView : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) BMPLoadStations *stationsLoader;

typedef NS_ENUM(NSUInteger, BMPzoomButtonValues) {
    BMPzoomPlus,
    BMPzoomCenter,
    BMPzoomMinus,
};

-(void)zoomBtnClicked:(UIButton*)sender;
-(UIImage *)Circle: (CGFloat) radius and: (UIColor *) color;
-(UIImage *)overlayImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint) point;

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
-(UIImage *)buildStationIcon: (BOOL) electric and: (CGFloat) load;
-(void)annotateParkings: (NSDictionary *) parkings;

@end

