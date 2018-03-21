//
//  AppDelegate.h
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray *deviceId;
@property NSMutableArray *fileDesc;
@property NSMutableArray<UIImage *> *photos;
@property long focusImageIndex;
@property bool isSending;
/*
 *  For Video
 */
@property NSMutableArray<NSData *> *videos;
@property NSMutableArray *completedUnitPercent;

@property NSMutableArray *deviceList;


- (void)clearProperty;
- (void)saveDeviceList:(NSMutableDictionary *) device;
- (void)loadDeviceList;

@end

