//
//  ViewController.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPStationsMapView.h"
#import <MapKit/MapKit.h>
#import "BMPAnnotation.h"
#import "BMPLoadStations.h"
#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#define DEBUGGING YES

static CGFloat const TOOFAR_LABEL_HEIGHT = 60;

@interface BMPStationsMapView ()

@property (nonatomic, strong) MKMapView *bikesMap;
@property (nonatomic, strong) UILabel *labelOnTopOfMap;
@property (nonatomic, assign) BOOL locationWasObtained;
@property (nonatomic, strong) UIImage* bikeIcon;
@property (nonatomic, strong) NSMutableDictionary *bikeIcons;
@property (nonatomic, strong) NSRegularExpression *aRegx;

@end

@implementation BMPStationsMapView

-(instancetype)init {
    self = [super init];
    
    _bikeIcon = [UIImage imageNamed:@"station icon 18 black"];
    
    NSString *regexStr=@".+(Механическая|Электрическая).\\n([0-9]+) мест. Свободных ([0-9]+)";
    _aRegx=[NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];

    return self;
}


#pragma mark System methods

- (void)viewDidLoad {
    //+ move code from didload to subs
    
    [super viewDidLoad];
    _locationWasObtained = NO;
   
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height; //столько надо отступить снизу чтобы не прятать данные под таббаром
    
    _bikeIcons = [NSMutableDictionary new];
    
    _bikesMap = [MKMapView new];
    _bikesMap.delegate = self;
    _bikesMap.showsUserLocation = YES;
    
    [self.view addSubview:_bikesMap];
    
    // position map view
    _bikesMap.translatesAutoresizingMaskIntoConstraints = NO;
    id views = @{ @"mapView": _bikesMap };
    NSString *verticalConstraint = [[NSString alloc] initWithFormat:@"V:|[mapView]-%d-|", (int)tabBarHeight];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|"    options:0 metrics:nil views:views]];
    
    // move view to moscow
    MKCoordinateRegion region = {{55.755786, 37.617633}, MKCoordinateSpanMake(0.40, 0.51)};
    [self.bikesMap setRegion:region animated:YES];

    // implement zoom plus, minus, center buttons
    static CGFloat const imageRightOffset = 0.2;   // in button image width X
    static CGFloat const imagesTopOffset = 0.1;   // in screen size height X
    UIButton *zoomPlusButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"zoomplus"];
    [zoomPlusButton setImage:buttonImage forState: UIControlStateNormal];
    zoomPlusButton.frame = CGRectMake(self.view.bounds.size.width-buttonImage.size.width*(1+imageRightOffset), self.view.bounds.size.height*imagesTopOffset, buttonImage.size.width, buttonImage.size.height);
    zoomPlusButton.tag = BMPzoomPlus;
    [zoomPlusButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:zoomPlusButton];
    
    UIButton *locateButton = [UIButton buttonWithType: UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"zoomcenter"];
    [locateButton setImage:buttonImage forState: UIControlStateNormal];
    locateButton.frame = CGRectMake(self.view.bounds.size.width-buttonImage.size.width*(1+imageRightOffset), self.view.bounds.size.height*imagesTopOffset+buttonImage.size.height, buttonImage.size.width, buttonImage.size.height);
    locateButton.tag = BMPzoomCenter;
    [locateButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:locateButton];
    
    UIButton *zoomMinusButton = [UIButton buttonWithType: UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"zoomminus"];
    [zoomMinusButton setImage:buttonImage forState: UIControlStateNormal];
    zoomMinusButton.frame = CGRectMake(self.view.bounds.size.width-buttonImage.size.width*(1+imageRightOffset), self.view.bounds.size.height*imagesTopOffset+2*buttonImage.size.height, buttonImage.size.width, buttonImage.size.height);
    zoomMinusButton.tag = BMPzoomMinus;
    [zoomMinusButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:zoomMinusButton];
    
    // add a label to show misc information
    _labelOnTopOfMap = [UILabel new];
    _labelOnTopOfMap.font = [UIFont boldSystemFontOfSize: 18.0];
    _labelOnTopOfMap.textAlignment = NSTextAlignmentCenter;
    _labelOnTopOfMap.hidden = YES;
    _labelOnTopOfMap.lineBreakMode = NSLineBreakByWordWrapping;
    _labelOnTopOfMap.numberOfLines = 0;
    _labelOnTopOfMap.frame = CGRectMake(0, (self.view.bounds.size.height-TOOFAR_LABEL_HEIGHT)/2, self.view.bounds.size.width, TOOFAR_LABEL_HEIGHT);
    [self.view addSubview:_labelOnTopOfMap];
    _labelOnTopOfMap.text = @"Loading stations,\nplease wait";
    _labelOnTopOfMap.textColor = [UIColor blackColor];


//    // start getting stations from api or local file
    NSDictionary * parkings;
    _labelOnTopOfMap.hidden = NO;
    parkings = [BMPLoadStations loadStations];
    _labelOnTopOfMap.hidden = YES;

//    NSLog(@"init stations");
    [self annotateParkings: [parkings objectForKey:@"Items"]];

    _labelOnTopOfMap.text = @"You got too far from Moscow,\nplease fly back :)";
    _labelOnTopOfMap.textColor = [UIColor redColor];
}

- (void)annotateParkings: (NSDictionary *) parkings {
    if (DEBUG) { NSLog(@"annotating %d stations", [parkings count]); }
    //dlog
    BMPAnnotation * annot;
    for (NSDictionary * station in parkings) {
        annot = [[BMPAnnotation alloc] initWithDict:station];
        
        [_bikesMap addAnnotation:annot];
    }
}

- (void)zoomBtnClicked:(UIButton*)sender{
    if (DEBUGGING) { NSLog(@"%d icons init", [_bikeIcons count]); }
    switch (sender.tag)
    {
        case BMPzoomPlus: {
            MKCoordinateRegion region = _bikesMap.region;
            MKCoordinateSpan span = _bikesMap.region.span;
            span.latitudeDelta/=2;
            span.longitudeDelta/=2;
            region.span=span;
            [_bikesMap setRegion:region animated:YES]; }
            break;
            
        case BMPzoomCenter: if (_locationWasObtained) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta = 0.05;
            span.longitudeDelta = 0.05;
            CLLocationCoordinate2D location;
            location.latitude = _bikesMap.userLocation.coordinate.latitude;
            location.longitude = _bikesMap.userLocation.coordinate.longitude;
            region.span = span;
            region.center = location;
            [_bikesMap setRegion:region animated:YES]; }
            break;
            
        case BMPzoomMinus: {
            MKCoordinateRegion region = _bikesMap.region;
            MKCoordinateSpan span = _bikesMap.region.span;
            span.latitudeDelta*=2;
            span.longitudeDelta*=2;
            region.span=span;
            [_bikesMap setRegion:region animated:YES]; }
            break;

        default: {
            NSLog(@"wtf?");
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Map methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (DEBUGGING) { NSLog(@"did update location map"); } //this one works
    _locationWasObtained = YES;
    
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [_bikesMap setRegion:region animated:YES];
    
    
    CLLocationCoordinate2D MoscowCenter = {55.755786, 37.617633};
    CLLocation *MoscowLocation = [[CLLocation alloc]
                               initWithLatitude:MoscowCenter.latitude
                               longitude:MoscowCenter.longitude];
    CLLocation *myLocation = [[CLLocation alloc]
                                initWithLatitude:userLocation.coordinate.latitude
                                longitude:userLocation.coordinate.longitude];
    
    CLLocationDistance distance = [MoscowLocation distanceFromLocation:myLocation];
    
//    NSLog(@"%@", [NSString stringWithFormat:@"Distance to point %4.0f m.", distance]);
    if (distance > 20000) {
//        NSLog(@"you got too far from moscow");
        _labelOnTopOfMap.hidden = NO;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"location error" message:@"You got too far from Moscow, please fly back :)" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        _labelOnTopOfMap.hidden = YES;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //dequeue?
    if ([annotation isKindOfClass:[MKUserLocation class]]) {    // no special annotation for @"My Location"]
        return nil; }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"bike-station"];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = annotation.subtitle;
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    annView.detailCalloutAccessoryView = lbl;   // our label is set as the view to display for annotation details
    
    // Following lets the callout still work if you tap on the label...
    annView.canShowCallout = YES;
    annView.frame = lbl.frame;
    
    annView.canShowCallout = YES;
    annView.userInteractionEnabled = YES;

    // @"ул. Селезнёвская, д.29, стр.1. Механическая.\n12 мест. Свободных 9";
    // we dissect such strings into 3 parts by previously prepared regular expression
    NSArray *results=[_aRegx matchesInString:lbl.text options:0 range:NSMakeRange(0, lbl.text.length)];
    NSTextCheckingResult *match = results[0];
    BOOL is_electric   =  ([[lbl.text substringWithRange:[match rangeAtIndex:1]] isEqualToString:@"Электрическая"]) ? YES : NO;
    NSString *totalPlaces = [lbl.text substringWithRange:[match rangeAtIndex:2]];
    NSString *freePlaces  = [lbl.text substringWithRange:[match rangeAtIndex:3]];
    
    CGFloat percent = [freePlaces floatValue] / [totalPlaces floatValue];
    
    annView.image = [self buildStationIcon:is_electric and:1-percent];
//    annView.tintColor
    return annView;
}

#pragma mark - graphics methods

-(UIImage *)buildStationIcon: (BOOL) electric and: (CGFloat) load {
    UIImage *whatWeBuild;
    NSString *key = [NSString stringWithFormat:@"%@ %.02f", electric?@"e":@"m", load];
    if (nil==[_bikeIcons objectForKey:key]) {   //caches icons based on their key values like "m 1.0000"
        UIColor *thiscolor = [UIColor colorWithHue: load saturation:1.0 brightness:1.0 alpha:1.0];
        // insert different circle for electric bike
        UIImage *circleIcon = [BMPStationsMapView Circle:18.0f and: thiscolor];
        whatWeBuild = [BMPStationsMapView overlayImage:_bikeIcon inImage:circleIcon atPoint:CGPointMake(0, 3)];
        [_bikeIcons setObject:whatWeBuild forKey:key];
        return whatWeBuild; //it returns differently coloured icons but they are not being drawn
    } else {
        return [_bikeIcons objectForKey:key];
    };
}

+(UIImage *)overlayImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint) point {
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)Circle: (CGFloat) radius and: (UIColor *) color {
    __block UIImage *Circle = nil;
    dispatch_once_t onceToken = nil; //+ =0 and delete dispatch_once completely!
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius, radius), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, radius, radius);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        Circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();        
    });
    return Circle;
}

@end
