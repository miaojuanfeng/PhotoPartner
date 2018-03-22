//
//  AppDelegate.h
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray *deviceList;
@property NSMutableArray *deviceId;
@property NSMutableArray *fileDesc;
@property NSMutableArray<UIImage *> *photos;
@property long focusImageIndex;
/*
 *  For Video
 */
@property NSMutableArray<NSData *> *videos;
@property NSMutableArray *completedUnitPercent;
@property NSString *md5;
//
@property MBProgressHUD *hudLoading;
@property MBProgressHUD *hudToast;
@property MBProgressHUD *hudWaiting;
/*
 *  For Function
 */
- (void)clearProperty;
- (void)saveDeviceList:(NSMutableDictionary *) device;
- (void)loadDeviceList;
- (bool)doDataToBlock:(NSData *) videoData;
- (NSString *)md5:(NSString *) string;

@end

