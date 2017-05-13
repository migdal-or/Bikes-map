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

// static const
static CGFloat const TOOFAR_LABEL_HEIGHT = 60;

@interface BMPStationsMapView ()

@property (nonatomic, strong) MKMapView *bikesMap;
@property (nonatomic, strong) UILabel *youGotTooFarLabel;
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) BOOL locationWasObtained;

@end

@implementation BMPStationsMapView

#pragma mark System methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationWasObtained = NO;
   
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height; //столько надо отступить снизу чтобы не прятать данные под таббаром
    
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
    MKCoordinateRegion region = {{55.755786, 37.617633}, MKCoordinateSpanMake(0.40, 0.51)};
    [self.bikesMap setRegion:region animated:YES];

    UIButton *zoomPlusButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"zoomplus"]; //TODO 5
    [zoomPlusButton setImage:buttonImage forState: UIControlStateNormal];
    zoomPlusButton.frame = CGRectMake(self.view.bounds.size.width-50, 100, buttonImage.size.width, buttonImage.size.height);
    zoomPlusButton.tag = BMPzoomPlus;
    [zoomPlusButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:zoomPlusButton];
    
    UIButton *locateButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [locateButton setImage:[UIImage imageNamed:@"zoomcenter"] forState: UIControlStateNormal];
    locateButton.frame = CGRectMake(self.view.bounds.size.width-50, 139, 41, 39);
    locateButton.tag = BMPzoomCenter;
    [locateButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:locateButton];
    
    UIButton *zoomMinusButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [zoomMinusButton setImage:[UIImage imageNamed:@"zoomminus"] forState: UIControlStateNormal];
    zoomMinusButton.frame = CGRectMake(self.view.bounds.size.width-50, 178, 41, 39);
    zoomMinusButton.tag = BMPzoomMinus;
    [zoomMinusButton addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bikesMap addSubview:zoomMinusButton];
    
//    // start getting stations from api or local file
    NSDictionary * parkings;
    parkings = [BMPLoadStations loadStations];
    
//    NSLog(@"init stations");
    [self annotateParkings: [parkings objectForKey:@"Items"]];

//    NSData *data;
//    
//    if (LOCAL_MODE) {
//        data = [[NSData alloc] initWithContentsOfFile:ARCHIVE_FILE_PATH];
//        parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"init stations from file done");
//        [self annotateParkings: [parkings objectForKey:@"Items"]];
//    } else {
//        NSMutableURLRequest *request = [NSMutableURLRequest
//                                        requestWithURL:[NSURL URLWithString:@"http://apivelobike.velobike.ru/ride/parkings"]
//                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                      timeoutInterval:10.0];
//        [request setHTTPMethod:@"GET"];
//        
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                        if (error) {
//                                                            NSLog(@"%@", error);
//                                                        } else {
////                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
////                                                            NSLog(@"%@", httpResponse);
//                                                            parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                                                            if (STORE_FILE) {
//                                                                if ([data writeToFile:ARCHIVE_FILE_PATH atomically:YES]) {
//                                                                    NSLog(@"archiving ok");
//                                                                } else {
//                                                                    NSLog(@"archiving failed");
//                                                                };
//                                                            } else {
//                                                                NSLog(@"not archiving file to local because of defines setup");
//                                                            }
//                                                            [self annotateParkings: [parkings objectForKey:@"Items"]];
//                                                        }
//                                                        
//                                                    }];
//        [dataTask resume];
//    }
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

- (void)zoomBtnClicked:(UIButton*)sender{
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
//    NSLog(@"did update location map"); //this one works
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
