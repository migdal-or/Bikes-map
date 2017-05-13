//
//  BMPLoadStations.m
//  Bikes map try4
//
//  Created by iOS-School-1 on 13/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BMPLoadStations.h"
#define LOCAL_MODE YES // just to skip all this iTunes bullshit and load data from local file )
#define STORE_FILE NO // save itunes data if non-local mode call?
#define ARCHIVE_FILE_PATH @"/Users/admin/Desktop/bicycles.data"

@interface BMPLoadStations ()

@property (nonatomic, strong) NSDictionary* stations;

@end

@implementation BMPLoadStations

static NSDictionary * parkings;

+(NSDictionary *)loadStations {
    // DONE TODO 1. Save stations object and return cached copy between calls if the object has already been retrieved
    if (nil == parkings) {
        __block NSDictionary * local_parkings;
        // start getting stations from api or local file
        NSData *data;
        
        if (LOCAL_MODE) {
            data = [[NSData alloc] initWithContentsOfFile:ARCHIVE_FILE_PATH];
            local_parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
                                                                local_parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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
            while (nil == local_parkings) { // do never do like this!
                NSLog(@"wait");
                usleep(100000); }
        }
        parkings = local_parkings;
    }
    return parkings;
}
@end
