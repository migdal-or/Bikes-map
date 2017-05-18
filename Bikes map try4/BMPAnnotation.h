//
//  BMPAnnotation.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 11/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMPAnnotation : NSObject<MKAnnotation>

//+ написать документирующий комментарий **/

/**
 Делает из словарика описывающего станцию - аннотацию для карты

 @param parameters берёт nsdictionary полученный из JSON от API
 @return возвращает объект со свойствами аннотации: координата, заголовок, описание
 */
- (_Nullable instancetype)initWithDictionary:(nonnull NSDictionary *)parameters;
//+nullable - nonnull, писать полностью dictionary, писать nsdictionary<nsstring*,nsstring*)*
//+ из конструкторов не возвращаем id, возвращаем instancetype

@end
