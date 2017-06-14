//
//  GpsManager.m
//  biufang
//
//  Created by 娄耀文 on 16/10/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "GpsManager.h"

@implementation GpsManager

+ (id) sharedGpsManager {
    static id s;
    if (s == nil) {
        s = [[GpsManager alloc] init];
    }
    return s;
}
- (id)init {
    self = [super init];
    if (self) {
        // 打开定位 然后得到数据
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项
         NSLocationAlwaysUsageDescription      Boolean YES
         NSLocationWhenInUseUsageDescription   Boolean YES
         */

        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
        }

        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8) {
            [manager requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (void) getGps:(  void (^)(double lat, double lng, NSString *city) )cb {
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        return;
    }
    // block一般赋值需要copy
    saveGpsCallback = [cb copy];
    
    // 停止上一次的
    [manager stopUpdatingLocation];
    // 开始新的数据定位
    [manager startUpdatingLocation];
}

+ (void) getGps:(  void (^)(double lat, double lng, NSString *city) )cb {
    [[GpsManager sharedGpsManager] getGps:cb];
}

- (void) stop {
    [manager stopUpdatingLocation];
}

+ (void) stop {
    [[GpsManager sharedGpsManager] stop];
}

// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[GpsManager sharedGpsManager] stop];
    
    for (CLLocation *loc in locations) {
        CLLocationCoordinate2D l = loc.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        
        CLLocation *newLocation = locations[0];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            for (CLPlacemark *place in placemarks) {

                NSString *city = place.locality;
                if (saveGpsCallback) {
                    saveGpsCallback(lat, lnt, city);
                    
                }
            }
        }];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败");
    saveGpsCallback(0, 0, nil);
}

@end
