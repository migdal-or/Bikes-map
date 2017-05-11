//
//  ViewController.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 10/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPStationsMapView.h"
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "BMPAnnotation.h"

// static const
static CGFloat const TABBAR_HEIGHT = 100;
static CGFloat const TOOFAR_LABEL_HEIGHT = 60;

#define LOCAL_MODE YES // just to skip all this iTunes bullshit and load data from local file )
#define STORE_FILE YES // save itunes data if non-local mode call?
#define ARCHIVE_FILE_PATH @"/Users/admin/Desktop/bicycles.data"

@interface BMPStationsMapView ()

@property (nonatomic, strong) MKMapView *bikesMap;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UILabel * youGotTooFarLabel;

@end

@implementation BMPStationsMapView

#pragma mark System methods

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-TABBAR_HEIGHT, self.view.bounds.size.width, TABBAR_HEIGHT)];
    
    UIButton *tellCoordsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"logo"];
    tellCoordsButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [tellCoordsButton setImage:buttonImage forState:UIControlStateNormal];
    [tellCoordsButton addTarget:self action:@selector(tellCoords:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar setBackgroundColor:[UIColor redColor]];

    [_toolBar addSubview:tellCoordsButton];
    [self.view addSubview:_toolBar];
    
    _bikesMap = [MKMapView new];
    _bikesMap.delegate = self;
    _bikesMap.showsUserLocation = YES;
    
    [self.view addSubview:_bikesMap];
    
    // position map view
    _bikesMap.translatesAutoresizingMaskIntoConstraints = NO;
    id views = @{ @"mapView": _bikesMap , @"toolBar": _toolBar };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    // replace TABBAR_HEIGHT here
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]-100-|" options:0 metrics:nil views:views]];
    
    // add a label to show if you are too far
    _youGotTooFarLabel = [UILabel new];
    _youGotTooFarLabel.font = [UIFont boldSystemFontOfSize: 18.0];
    _youGotTooFarLabel.text = @"You got too far from Moscow,\nplease fly back :)";
    _youGotTooFarLabel.textAlignment = NSTextAlignmentCenter;
    _youGotTooFarLabel.textColor = [UIColor redColor];
    _youGotTooFarLabel.hidden = YES;
    _youGotTooFarLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _youGotTooFarLabel.numberOfLines = 0;
    _youGotTooFarLabel.frame = CGRectMake(0, (self.view.bounds.size.height-TOOFAR_LABEL_HEIGHT)/2, self.view.bounds.size.width, TOOFAR_LABEL_HEIGHT);
    [self.view addSubview:_youGotTooFarLabel];

    // move view to moscow
    MKCoordinateSpan span = MKCoordinateSpanMake(0.40, 0.51);
    CLLocationCoordinate2D coordinate = {55.755786, 37.617633};
    MKCoordinateRegion region = {coordinate, span};
    [self.bikesMap setRegion:region animated:YES];

    
    
    // start getting stations from api or local file
    __block NSDictionary * parkings;
    NSData *data;
    
    if (LOCAL_MODE) {
        data = [[NSData alloc] initWithContentsOfFile:ARCHIVE_FILE_PATH];
        parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"init stations from file done");
        [self annotateParkings: [parkings objectForKey:@"Items"]];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://apivelobike.velobike.ru/ride/parkings"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
//                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                            NSLog(@"%@", httpResponse);
                                                            parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                            if (STORE_FILE) {
                                                                if ([data writeToFile:ARCHIVE_FILE_PATH atomically:YES]) {
                                                                    NSLog(@"archiving ok");
                                                                } else {
                                                                    NSLog(@"archiving failed");
                                                                };
                                                            } else {
                                                                NSLog(@"not archiving file to local because of defines setup");
                                                            }
                                                            [self annotateParkings: [parkings objectForKey:@"Items"]];
                                                        }
                                                        
                                                    }];
        [dataTask resume];
    }
}

- (void)annotateParkings: (NSDictionary *) parkings {
    NSLog(@"annotating %d stations", [parkings count]);
    CLLocationCoordinate2D coordinate;
    for (NSArray* station in parkings) {
        coordinate.latitude  = [[[station valueForKey:@"Position"] valueForKey:@"Lat"] doubleValue];
        coordinate.longitude = [[[station valueForKey:@"Position"] valueForKey:@"Lon"] doubleValue];
        BMPAnnotation * annot = [[BMPAnnotation alloc] initWithTitle:[station valueForKey:@"Id"]
                                                            subtitle:[station valueForKey:@"Address"]
                                                            location:coordinate];
        [_bikesMap addAnnotation:annot];
    }
}

- (void)tellCoords: (MKUserLocation *)userLocation {
    NSLog(@"%f %f", _bikesMap.userLocation.location.coordinate.latitude, _bikesMap.userLocation.location.coordinate.longitude);
    NSLog(@"%f, %f", [_bikesMap region].span.latitudeDelta, [_bikesMap region].span.longitudeDelta);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Map methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"did update location map"); //this one works
    
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
    
    NSLog(@"%@", [NSString stringWithFormat:@"Distance to point %4.0f m.", distance]);
    if (distance > 20000) {
        NSLog(@"you got too far from moscow");
        _youGotTooFarLabel.hidden = NO;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"location error" message:@"You got too far from Moscow, please fly back :)" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        _youGotTooFarLabel.hidden = YES;

    }
}

-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"start load map");
}
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    NSLog(@"will start locate");
}

@end
