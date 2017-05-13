//
//  BMPLoadStations.m
//  Bikes map try4
//
//  Created by iOS-School-1 on 13/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BMPLoadStations.h"
#define LOCAL_MODE YES // just to skip all this iTunes bullshit and load data from local file )
#define STORE_FILE YES // save itunes data if non-local mode call?
#define ARCHIVE_FILE_PATH @"/Users/admin/Desktop/bicycles.data"

@interface BMPLoadStations ()

@property (nonatomic, strong) NSArray* stations;

@end

@implementation BMPLoadStations

+(NSDictionary *)loadStations {
    
    // start getting stations from api or local file
    __block NSDictionary * parkings;
    NSData *data;
    
    if (LOCAL_MODE) {
        data = [[NSData alloc] initWithContentsOfFile:ARCHIVE_FILE_PATH];
        parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:@"http://apivelobike.velobike.ru/ride/parkings"]
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
                                                        }
                                                        
                                                    }];
        [dataTask resume];
    }
    return parkings;
}
@end
