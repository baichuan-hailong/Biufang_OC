//
//  GpsManager.h
//  biufang
//
//  Created by 娄耀文 on 16/10/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GpsManager : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager *manager;
    void (^saveGpsCallback) (double lat, double lng, NSString *city);
}

+ (void) getGps:(  void (^)(double lat, double lng, NSString *city) )cb;
+ (void) stop;


@end
