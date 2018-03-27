//
//  ViewController.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "MacroDefine.h"
#import "AppDelegate.h"
#import "HomeController.h"
#import "UploadPhotoController.h"
#import "UploadVideoController.h"
#import "DeviceController.h"
#import "AddDeviceController.h"
#import "MessageController.h"
#import "SettingController.h"
//#import <MobileCoreServices/MobileCoreServices.h>
#import "GSKeyChainDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import <TZImageManager.h>
#import <Photos/Photos.h>

@interface HomeController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property UIAlertController *actionSheet;
@property AppDelegate *appDelegate;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"homeNavigationItemTitle", nil);
    self.navigationController.delegate = self;
    
    VIEW_WIDTH = VIEW_WIDTH - GAP_WIDTH * 2;
    VIEW_HEIGHT = VIEW_HEIGHT - GAP_HEIGHT * 3 -20;
//    MARGIN_TOP -= GET_LAYOUT_HEIGHT(self.navigationController.navigationBar);
//    VIEW_HEIGHT += GET_LAYOUT_HEIGHT(self.navigationController.navigationBar);
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *topBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, MARGIN_TOP+20, VIEW_WIDTH, VIEW_HEIGHT/4-20)];
    UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(topBoxView), GET_LAYOUT_HEIGHT(topBoxView))];
//    [takePhotoButton setTitle:NSLocalizedString(@"homeTakePhotoTitle", nil) forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(clickTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
    
    [takePhotoButton setImage:[UIImage imageNamed:@"pictures_bg"] forState:UIControlStateNormal];
    takePhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIView *takePhotoIcon = [[UIView alloc] initWithFrame:CGRectMake((GET_LAYOUT_WIDTH(topBoxView)-80)/2, (GET_LAYOUT_HEIGHT(topBoxView)-80)/2, 80, 80)];
    takePhotoIcon.userInteractionEnabled = NO;
    
    UIImageView *takePhotoIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(takePhotoIcon), GET_LAYOUT_HEIGHT(takePhotoIcon))];
    takePhotoIconImage.image = [UIImage imageNamed:@"pictures"];
    [takePhotoIcon addSubview:takePhotoIconImage];
    UILabel *takePhotoIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, GET_LAYOUT_WIDTH(takePhotoIcon), 20)];
    takePhotoIconLabel.textAlignment = NSTextAlignmentCenter;
    takePhotoIconLabel.textColor = [UIColor whiteColor];
    takePhotoIconLabel.text = NSLocalizedString(@"homeTakePhotoTitle", nil);
    [takePhotoIcon addSubview:takePhotoIconLabel];
    
    [takePhotoButton addSubview:takePhotoIcon];
    
    [topBoxView addSubview:takePhotoButton];
    [self.view addSubview:topBoxView];
    
    UIView *centerBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, GET_LAYOUT_OFFSET_Y(topBoxView)+GET_LAYOUT_HEIGHT(topBoxView)+GAP_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT / 2)];
//    centerBoxView.backgroundColor = [UIColor redColor];
    UIView *centerLeftBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (GET_LAYOUT_WIDTH(centerBoxView)-GAP_WIDTH)/2, GET_LAYOUT_HEIGHT(centerBoxView))];
//    centerLeftBoxView.backgroundColor = [UIColor lightGrayColor];
    UIButton *takeVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(centerLeftBoxView), (GET_LAYOUT_HEIGHT(centerLeftBoxView)-GAP_HEIGHT)/3*2)];
//    takeVideoButton.backgroundColor = [UIColor redColor];
//    [takeVideoButton setTitle:NSLocalizedString(@"homeTakeVodioTitle", nil) forState:UIControlStateNormal];
    [takeVideoButton addTarget:self action:@selector(clickTakeVideoButton) forControlEvents:UIControlEventTouchUpInside];
    
    [takeVideoButton setImage:[UIImage imageNamed:@"video_recording_bg"] forState:UIControlStateNormal];
    takeVideoButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIView *takeVideoIcon = [[UIView alloc] initWithFrame:CGRectMake((GET_LAYOUT_WIDTH(takeVideoButton)-80)/2, (GET_LAYOUT_HEIGHT(takeVideoButton)-80)/2, 80, 80)];
    takeVideoIcon.userInteractionEnabled = NO;
    
    UIImageView *takeVideoIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(takePhotoIcon), GET_LAYOUT_HEIGHT(takePhotoIcon))];
    takeVideoIconImage.image = [UIImage imageNamed:@"video_recording"];
    [takeVideoIcon addSubview:takeVideoIconImage];
    UILabel *takeVideoIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(takeVideoIcon)+GET_LAYOUT_HEIGHT(takeVideoIcon)+10, GET_LAYOUT_WIDTH(takeVideoButton), 20)];
    takeVideoIconLabel.textAlignment = NSTextAlignmentCenter;
    takeVideoIconLabel.textColor = [UIColor whiteColor];
    takeVideoIconLabel.text = NSLocalizedString(@"homeTakeVodioTitle", nil);
    [takeVideoButton addSubview:takeVideoIconLabel];
    
    [takeVideoButton addSubview:takeVideoIcon];
    
    
    [centerLeftBoxView addSubview:takeVideoButton];
    UIButton *deviceManageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(takeVideoButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(centerLeftBoxView), (GET_LAYOUT_HEIGHT(centerLeftBoxView)-GAP_HEIGHT)/3)];
    deviceManageButton.backgroundColor = [UIColor darkGrayColor];
    [deviceManageButton setTitle:NSLocalizedString(@"homeVideoLibTitle", nil) forState:UIControlStateNormal];
    [deviceManageButton addTarget:self action:@selector(clickVideoLibButton) forControlEvents:UIControlEventTouchUpInside];
    [centerLeftBoxView addSubview:deviceManageButton];
    [centerBoxView addSubview:centerLeftBoxView];
    UIView *centerRightBoxView = [[UIView alloc] initWithFrame:CGRectMake(GET_LAYOUT_WIDTH(centerLeftBoxView)+GAP_WIDTH, 0, (GET_LAYOUT_WIDTH(centerBoxView)-GAP_WIDTH)/2, centerBoxView.frame.size.height)];
//    centerRightBoxView.backgroundColor = [UIColor yellowColor];
    UIButton *photoLibButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(centerRightBoxView), (GET_LAYOUT_HEIGHT(centerRightBoxView)-GAP_HEIGHT)/3)];
    photoLibButton.backgroundColor = [UIColor orangeColor];
    [photoLibButton setTitle:NSLocalizedString(@"homePhotoLibTitle", nil) forState:UIControlStateNormal];
    [photoLibButton addTarget:self action:@selector(clickPhotoLibButton) forControlEvents:UIControlEventTouchUpInside];
    [centerRightBoxView addSubview:photoLibButton];
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(photoLibButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(centerRightBoxView), (GET_LAYOUT_HEIGHT(centerRightBoxView)-GAP_HEIGHT)/3*2)];
    messageButton.backgroundColor = [UIColor greenColor];
//    [messageButton setTitle:NSLocalizedString(@"messageNavigationItemTitle", nil) forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(clickMessageButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *messageIcon = [[UIView alloc] initWithFrame:CGRectMake((GET_LAYOUT_WIDTH(takeVideoButton)-80)/2, (GET_LAYOUT_HEIGHT(takeVideoButton)-80)/2, 80, 80)];
    messageIcon.userInteractionEnabled = NO;
    
    UIImageView *messageIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(messageIcon), GET_LAYOUT_HEIGHT(messageIcon))];
    messageIconImage.image = [UIImage imageNamed:@"message"];
    [messageIcon addSubview:messageIconImage];
    UILabel *messageIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(messageIcon)+GET_LAYOUT_HEIGHT(messageIcon)+10, GET_LAYOUT_WIDTH(messageButton), 20)];
    messageIconLabel.textAlignment = NSTextAlignmentCenter;
    messageIconLabel.textColor = [UIColor whiteColor];
    messageIconLabel.text = NSLocalizedString(@"messageNavigationItemTitle", nil);
    [messageButton addSubview:messageIconLabel];
    
    [messageButton addSubview:messageIcon];
    
    
    
    [centerRightBoxView addSubview:messageButton];
    [centerBoxView addSubview:centerRightBoxView];
    [self.view addSubview:centerBoxView];
    
    UIView *bottomBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, GET_LAYOUT_OFFSET_Y(centerBoxView)+GET_LAYOUT_HEIGHT(centerBoxView)+GAP_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT/4+20)];
//    bottomBoxView.backgroundColor = [UIColor yellowColor];
    UIButton *bindDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(bottomBoxView), (GET_LAYOUT_HEIGHT(bottomBoxView)-GAP_HEIGHT)/2)];
    bindDeviceButton.backgroundColor = [UIColor redColor];
    [bindDeviceButton setTitle:NSLocalizedString(@"deviceListNavigationItemTitle", nil) forState:UIControlStateNormal];
    [bindDeviceButton addTarget:self action:@selector(clickDeviceManageButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomBoxView addSubview:bindDeviceButton];
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(bindDeviceButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(bottomBoxView), (GET_LAYOUT_HEIGHT(bottomBoxView)-GAP_HEIGHT)/2)];
    settingButton.backgroundColor = [UIColor blueColor];
    [settingButton setTitle:NSLocalizedString(@"settingNavigationItemTitle", nil) forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomBoxView addSubview:settingButton];
    [self.view addSubview:bottomBoxView];
    
    
    
    
    
    
    NSString *deviceUUID = [GSKeyChainDataManager readUUID];
    NSLog(@"deviceUUID: %@", deviceUUID);
    if( deviceUUID == nil ){
        deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [GSKeyChainDataManager saveUUID:deviceUUID];
        NSLog(@"重新生成deviceUUID: %@", deviceUUID);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    NSDictionary *parameters=@{@"user_imei":deviceUUID};
    HUD_WAITING_SHOW(NSLocalizedString(@"hudLoading", nil));
    [manager POST:BASE_URL(@"user/signin") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            
            HUD_LOADING_PROGRESS(progress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
        int status = [[dic objectForKey:@"status"] intValue];
        
        HUD_WAITING_HIDE;
        if( status == 200 ){
            self.appDelegate.userInfo =  [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
        }
        NSLog(@"userInfo: %@", self.appDelegate.userInfo);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        
        HUD_WAITING_HIDE;
//        HUD_TOAST_SHOW(NSLocalizedString(@"networkError", nil));
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"networkError", nil)
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmOK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clickQuitButton];
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"current view controller: %@", [viewController class]);
    NSLog(@"is hidden: %d", [viewController isKindOfClass: NSClassFromString(@"CAMImagePickerCameraViewController")]);
    BOOL isHidden = NO;
    if( [viewController isKindOfClass:[self class]] ||
        [viewController isKindOfClass: NSClassFromString(@"CAMImagePickerCameraViewController")] ||
        [viewController isKindOfClass: NSClassFromString(@"PUPhotoPickerHostViewController")] ||
        [viewController isKindOfClass: NSClassFromString(@"PUUIAlbumListViewController")] ){
        isHidden = YES;
    }
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}



#pragma mark - Button Action


- (void)clickTakePhotoButton {
//    UploadPhotoController *uploadPhotoController = [[UploadPhotoController alloc] init];
//    [self.navigationController pushViewController:uploadPhotoController animated:YES];
//    return;
    
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
//        [self.activityIndicator startAnimating];
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            pickerController.allowsEditing = YES;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

- (void)clickPhotoLibButton {
//    self.actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UploadPhotoController *uploadPhotoController = [[UploadPhotoController alloc] init];
//        [self.navigationController pushViewController:uploadPhotoController animated:YES];
//    }];
//    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UploadVideoController *uploadVideoController = [[UploadVideoController alloc] init];
//        [self.navigationController pushViewController:uploadVideoController animated:YES];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
//    [self.actionSheet addAction:photoAction];
//    [self.actionSheet addAction:videoAction];
//    [self.actionSheet addAction:cancelAction];
//    [self presentViewController:self.actionSheet animated:YES completion:^{
//
//    }];
    UploadPhotoController *uploadPhotoController = [[UploadPhotoController alloc] init];
    [self.navigationController pushViewController:uploadPhotoController animated:YES];
}

- (void)clickVideoLibButton {
    UploadVideoController *uploadVideoController = [[UploadVideoController alloc] init];
    [self.navigationController pushViewController:uploadVideoController animated:YES];
}

- (void)clickTakeVideoButton{
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        //        [self.activityIndicator startAnimating];
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        pickerController.videoQuality = UIImagePickerControllerQualityType640x480;
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        //            pickerController.allowsEditing = YES;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

- (void)clickMessageButton {
    MessageController *messageController = [[MessageController alloc] init];
    [self.navigationController pushViewController:messageController animated:YES];
}

- (void)clickSettingButton {
    SettingController *settingController = [[SettingController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)clickDeviceManageButton {
    DeviceController *deviceController = [[DeviceController alloc] init];
    [self.navigationController pushViewController:deviceController animated:YES];
}

//- (void)clickBindDeviceButton {
//    AddDeviceController *addDeviceController = [[AddDeviceController alloc] init];
//    [self.navigationController pushViewController:addDeviceController animated:YES];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [self.activityIndicator startAnimating];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@", info);
    if ([type isEqualToString:@"public.image"]) {
        
        //        NSURL *videoUrl=(NSURL*) [info objectForKey:UIImagePickerControllerReferenceURL];
        
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeStamp = [date timeIntervalSince1970];
        NSString *timeStampString = [NSString stringWithFormat:@"%d", (int)floor(timeStamp)];
        
        NSLog(@"%@", timeStampString);
        
//        //拿到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [self fixOrientation:image];
        [self.appDelegate.photos addObject:image];
        [self.appDelegate.fileDesc addObject:@""];
        self.appDelegate.focusImageIndex = 0;
//        //设置一个图片的存储路径
//        NSString *imagePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),timeStampString];
//        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
//        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
//        self.photoName = timeStampString;
        
        
        //        // 读取沙盒路径图片
        //        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),timeStampString];
        //        // 拿到沙盒路径图片
        //        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
        //        self.imageView.image = imgFromUrl3;
        
        UploadPhotoController *uploadPhotoController = [[UploadPhotoController alloc] init];
        [self.navigationController pushViewController:uploadPhotoController animated:YES];
        
        //process image
        
    }else if([type isEqualToString:@"public.movie"]){
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
        player.shouldAutoplay = NO;
        UIImage  *thumbnail = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        player = nil;
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        NSLog(@"Total bytes %ld", [videoData length]);
        
        self.appDelegate.md5 =  [self.appDelegate md5:[videoURL absoluteString]];
        NSLog(@"视频md5计算完成,md5值为:%@", self.appDelegate.md5);
        
        if( ![self.appDelegate doDataToBlock:videoData] ){
            [self.appDelegate clearProperty];
            HUD_TOAST_SHOW(NSLocalizedString(@"uploadVideoMaxSizeError", nil));
            return;
        }
        
        [self.appDelegate.photos addObject:thumbnail];
        [self.appDelegate.fileDesc addObject:@""];
        self.appDelegate.focusImageIndex = 0;
        
        UploadVideoController *uploadVideoController = [[UploadVideoController alloc] init];
        [self.navigationController pushViewController:uploadVideoController animated:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self.activityIndicator stopAnimating];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell.contentView addSubview:self.photoButton];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.activityIndicator stopAnimating];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)clickQuitButton {
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIWindow *window = self.appDelegate.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        window.alpha = 0;
        
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        
    } completion:^(BOOL finished) {
        
        exit(0);
        
    }];
    
    //exit(0);
}

@end
