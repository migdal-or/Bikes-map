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

//+ написать документирующий комментарий **/
-(nullable id)initWithDict:(nonnull NSDictionary *)parameters; //+nullable - nonnull, писать полностью dictionary, писать nsdictionary<nsstring*,nsstring*)*
//+ из конструкторов не возвращаем id, возвращаем instancetype

@end
