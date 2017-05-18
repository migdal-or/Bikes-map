//
//  BMPLoadStations.h
//  Bikes map try4
//
//  Created by Dmitry A. Zvorykin on 13/05/2017.
//  Copyright © 2017 Dmitry A. Zvorykin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoaderDelegate;

@interface BMPLoadStations : NSObject

@property (nonatomic, weak) id<LoaderDelegate> delegate;

- (void)loadStations;

@end

@protocol LoaderDelegate <NSObject>
@required
- (void)didLoadStations:(NSDictionary *) parkings;
@end
