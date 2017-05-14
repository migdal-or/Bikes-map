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

typedef NS_ENUM(NSUInteger, BMPzoomButtonValues) {
    BMPzoomPlus,
    BMPzoomCenter,
    BMPzoomMinus,
};

+(UIImage *)changeWhiteColorTransparent: (UIImage *)image;
+(UIImage *)Circle: (CGFloat) radius and: (UIColor *) color;
+(UIImage *)overlayImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint) point;

@end

