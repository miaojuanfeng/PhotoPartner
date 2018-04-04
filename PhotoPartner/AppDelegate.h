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
//
@property NSMutableDictionary *userInfo;
@property NSMutableArray *deviceList;
@property NSMutableArray *messageList;
@property int appVersion;
//
@property NSMutableArray *deviceId;
@property NSMutableArray *fileDesc;
@property NSMutableArray<UIImage *> *photos;
//@property NSMutableArray *isTakePhoto;
@property long focusImageIndex;
/*
 *  For Video
 */
@property NSMutableArray<NSData *> *videos;
@property NSMutableArray *completedUnitPercent;
@property NSString *md5;
/*
 *  For Common UI
 */
@property MBProgressHUD *hudLoading;
@property MBProgressHUD *hudToast;
@property MBProgressHUD *hudWaiting;
/*
 *  For Function
 */
- (void)clearProperty;
- (void)clearPickerProperty;
- (void)addDeviceList:(NSMutableDictionary *) device;
- (void)saveDeviceList;
- (void)loadDeviceList;
- (void)addMessageList:(NSString *)type withTime:(NSString *) time withTitle:(NSString *) title withDesc:(NSString *) desc withData:(UIImage *) data;
- (void)saveMessageList;
- (void)loadMessageList;
- (void)clearMessageList;
- (bool)doDataToBlock:(NSData *) videoData;
- (NSString *)md5:(NSString *) string;

@end

