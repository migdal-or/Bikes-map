//
//  ViewController.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BMPStationsMapView : UIViewController<MKMapViewDelegate>

//typedef enum BMPzoomButtonValues : NSUInteger {
//} BMPzoomButtons;

typedef NS_ENUM(NSUInteger, BMPzoomButtonValues) {
    BMPzoomPlus,
    BMPzoomCenter,
    BMPzoomMinus,
//    UIControlContentVerticalAlignmentCenter  = 0,
//    UIControlContentVerticalAlignmentTop     = 1,
//    UIControlContentVerticalAlignmentBottom  = 2,
//    UIControlContentVerticalAlignmentFill    = 3,
};

@end

