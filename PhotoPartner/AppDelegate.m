//
//  AppDelegate.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "HomeController.h"
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [UINavigationBar appearance].barTintColor = RGBA_COLOR(27, 163, 232, 1);
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Init Global Varables
    self.deviceId = [[NSMutableArray alloc] init];
    self.fileDesc = [[NSMutableArray alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    self.focusImageIndex = -1;
    
    self.videos = [[NSMutableArray alloc] init];
    self.completedUnitPercent = [[NSMutableArray alloc] init];
    self.md5 = @"";
    
    [self loadDeviceList];
    if( self.deviceList == nil ){
        self.deviceList = [[NSMutableArray alloc] init];
    }
    self.userInfo = nil;
    self.appVersion = 11;
    
    [self loadMessageList];
    if( self.messageList == nil ){
        self.messageList = [[NSMutableArray alloc] init];
    }
    NSLog(@"ms: %@", self.messageList);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeController *homeController = [[HomeController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    self.hudLoading = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    self.hudLoading.mode = MBProgressHUDModeAnnularDeterminate;
    self.hudLoading.removeFromSuperViewOnHide = NO;
    [self.hudLoading hideAnimated:NO];
    
    self.hudWaiting = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    self.hudWaiting.mode = MBProgressHUDModeIndeterminate;
    self.hudWaiting.removeFromSuperViewOnHide = NO;
    [self.hudWaiting hideAnimated:NO];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)clearProperty {
    [self.deviceId removeAllObjects];
    [self.fileDesc removeAllObjects];
    [self.photos removeAllObjects];
    self.focusImageIndex = -1;
    // Video
    [self.videos removeAllObjects];
    [self.completedUnitPercent removeAllObjects];
    self.md5 = @"";
}

- (void)addDeviceList:(NSMutableDictionary *) device {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"deviceList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *newDic = nil;
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        newDic = [[NSMutableArray alloc] init];
    }else{
        newDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    [newDic addObject:device];
    [newDic writeToFile:plistPath atomically:YES];
}

- (void)saveDeviceList {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"deviceList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistPath error:nil];
    
    if( self.deviceList.count ){
        [self.deviceList writeToFile:plistPath atomically:YES];
    }
}

- (void)loadDeviceList {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"deviceList.plist"];
    self.deviceList = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)addMessageList:(NSString *)type withTime:(NSString *) time withTitle:(NSString *) title withDesc:(NSString *) desc withData:(UIImage *) data {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"messageList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *newDic = nil;
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        newDic = [[NSMutableArray alloc] init];
    }else{
        newDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    
    NSString *encodedImageStr = @"";
    if( data != nil ){
        NSData *_data = UIImageJPEGRepresentation(data, 1.0f);
        encodedImageStr = [_data base64Encoding];
    }
    
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    [message setObject:type forKey:@"type"];
    [message setObject:time forKey:@"time"];
    [message setObject:title forKey:@"title"];
    [message setObject:desc forKey:@"desc"];
    [message setObject:encodedImageStr forKey:@"data"];
    
    [self.messageList insertObject:message atIndex:0];
    
    [newDic insertObject:message atIndex:0];
    [newDic writeToFile:plistPath atomically:YES];
}

- (void)saveMessageList {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"messageList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistPath error:nil];
    
    if( self.messageList.count ){
        [self.messageList writeToFile:plistPath atomically:YES];
    }
}

- (void)loadMessageList {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"messageList.plist"];
    self.messageList = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)clearMessageList{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"messageList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistPath error:nil];
    
    self.messageList = [[NSMutableArray alloc] init];
}

- (bool)doDataToBlock:(NSData *) videoData{
    
    if( videoData.length > VIDEO_MAX_SIZE ){
        return false;
    }
    
    long videoChunkCount = 0;
    long lastChunkEnd = 0;
    if( videoData.length%VIDEO_CHUNK_SIZE == 0 ){
        videoChunkCount = videoData.length/VIDEO_CHUNK_SIZE;
    }else{
        videoChunkCount = videoData.length/VIDEO_CHUNK_SIZE + 1;
        lastChunkEnd = videoData.length%VIDEO_CHUNK_SIZE;
    }
    for (int i=0; i<videoChunkCount; i++) {
        if( i == videoChunkCount-1 ){
            [self.videos addObject:[videoData subdataWithRange:NSMakeRange(i*VIDEO_CHUNK_SIZE, lastChunkEnd)]];
        }else{
            [self.videos addObject:[videoData subdataWithRange:NSMakeRange(i*VIDEO_CHUNK_SIZE, VIDEO_CHUNK_SIZE)]];
        }
    }
    NSLog(@"%ld",self.videos.count);
    for (int i=0; i<self.videos.count; i++) {
        [self.completedUnitPercent addObject:@0];
    }
    
    return true;
}

- (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

@end
