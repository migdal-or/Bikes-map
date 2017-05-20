//
//  BMPLoadStations.m
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 13/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import "BMPLoadStations.h"
static BOOL const LOCAL_MODE = YES;  // just to skip all this networking bullshit and load data from local file )
static BOOL const STORE_FILE = NO;  // store net data if non-local mode call?
static NSString const *ARCHIVE_FILE_PATH = @"/Users/user/Desktop/bicycles.data"; //"/Users/admin/Desktop/bicycles.data"; //

@interface BMPLoadStations ()

@end

@implementation BMPLoadStations

static NSDictionary *parkings;

/**
 Загружает данные. Нам всё равно откуда. Вообще, по уму, в рабочей обстановке
 данные грузятся из АПИ велобайка, но для снижения нагрузки на сервера и освобождения
 от необходимости быть онлайн при отладке сделан механизм загрузки из локального
 файла дампа.
 
 @ param ничего не принимает, решение о том откуда грузить, принимается исходя из констант при билде
 @ return ничего не возвращает, запускает асинхронную загрузку и потом дёргает метод didLoadStations делегата
 */

- (void)loadStations {
    // DONE TODO 1. Save stations object and return cached copy between calls if the object has already been retrieved
    if (!parkings) {
        // start getting stations from api or local file
        NSData *data;
        if (LOCAL_MODE) {   // берём данные из локального файла или всё-таки из интернетов?
            data = [[NSData alloc] initWithContentsOfFile:ARCHIVE_FILE_PATH];
            NSDictionary *local_parkings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            parkings = local_parkings;
            dispatch_async(dispatch_get_main_queue(), ^{ [_delegate didLoadStations:parkings]; });
        } else {
            __block NSDictionary *local_parkings;
            NSMutableURLRequest *request;
            request = [NSMutableURLRequest
                       requestWithURL:[NSURL URLWithString:@"http://apivelobike.velobike.ru/ride/parkings"]
                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                       timeoutInterval:10.0];
            [request setHTTPMethod:@"GET"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask;
            dataTask = [session dataTaskWithRequest:request
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
                                      parkings = local_parkings;
                                      dispatch_async(dispatch_get_main_queue(), ^{ [_delegate didLoadStations:parkings]; });
                                  }];
            [dataTask resume];
        }
    } else {    // относится к if (!parkings)
    // в словаре parkings уже были данные, значит их уже загружали, значит можно вернуть сохранённую копию.
    dispatch_async(dispatch_get_main_queue(), ^{ [_delegate didLoadStations:parkings]; });
    }
}
@end
