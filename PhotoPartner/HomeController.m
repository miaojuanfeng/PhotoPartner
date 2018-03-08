//
//  ViewController.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "HomeController.h"
#import "UploadPhotoController.h"
#import "MessageController.h"
#import "SettingController.h"

@interface HomeController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"homeNavigationItemTitle", nil);
    self.navigationController.delegate = self;
    
    VIEW_WIDTH = VIEW_WIDTH - GAP_WIDTH * 2;
    VIEW_HEIGHT = VIEW_HEIGHT - GAP_HEIGHT * 3;
    
    UIView *topBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT/4-20)];
    UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(topBoxView), GET_LAYOUT_HEIGHT(topBoxView))];
    [takePhotoButton setTitle:@"拍照片" forState:UIControlStateNormal];
    takePhotoButton.backgroundColor = [UIColor blueColor];
    [takePhotoButton addTarget:self action:@selector(clickTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [topBoxView addSubview:takePhotoButton];
    [self.view addSubview:topBoxView];
    
    UIView *centerBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, GET_LAYOUT_OFFSET_Y(topBoxView)+GET_LAYOUT_HEIGHT(topBoxView)+GAP_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT / 2)];
//    centerBoxView.backgroundColor = [UIColor redColor];
    UIView *centerLeftBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (GET_LAYOUT_WIDTH(centerBoxView)-GAP_WIDTH)/2, GET_LAYOUT_HEIGHT(centerBoxView))];
//    centerLeftBoxView.backgroundColor = [UIColor lightGrayColor];
    UIButton *takeVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(centerLeftBoxView), (GET_LAYOUT_HEIGHT(centerLeftBoxView)-GAP_HEIGHT)/3*2)];
    takeVideoButton.backgroundColor = [UIColor redColor];
    [takeVideoButton setTitle:@"录视频" forState:UIControlStateNormal];
    [centerLeftBoxView addSubview:takeVideoButton];
    UIButton *deviceManageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(takeVideoButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(centerLeftBoxView), (GET_LAYOUT_HEIGHT(centerLeftBoxView)-GAP_HEIGHT)/3)];
    deviceManageButton.backgroundColor = [UIColor darkGrayColor];
    [deviceManageButton setTitle:@"设备管理" forState:UIControlStateNormal];
    [centerLeftBoxView addSubview:deviceManageButton];
    [centerBoxView addSubview:centerLeftBoxView];
    UIView *centerRightBoxView = [[UIView alloc] initWithFrame:CGRectMake(GET_LAYOUT_WIDTH(centerLeftBoxView)+GAP_WIDTH, 0, (GET_LAYOUT_WIDTH(centerBoxView)-GAP_WIDTH)/2, centerBoxView.frame.size.height)];
//    centerRightBoxView.backgroundColor = [UIColor yellowColor];
    UIButton *photoLibButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(centerRightBoxView), (GET_LAYOUT_HEIGHT(centerRightBoxView)-GAP_HEIGHT)/3)];
    photoLibButton.backgroundColor = [UIColor orangeColor];
    [photoLibButton setTitle:@"本地照片" forState:UIControlStateNormal];
    [photoLibButton addTarget:self action:@selector(clickPhotoLibButton) forControlEvents:UIControlEventTouchUpInside];
    [centerRightBoxView addSubview:photoLibButton];
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(photoLibButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(centerRightBoxView), (GET_LAYOUT_HEIGHT(centerRightBoxView)-GAP_HEIGHT)/3*2)];
    messageButton.backgroundColor = [UIColor greenColor];
    [messageButton setTitle:NSLocalizedString(@"messageNavigationItemTitle", nil) forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(clickMessageButton) forControlEvents:UIControlEventTouchUpInside];
    [centerRightBoxView addSubview:messageButton];
    [centerBoxView addSubview:centerRightBoxView];
    [self.view addSubview:centerBoxView];
    
    UIView *bottomBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, GET_LAYOUT_OFFSET_Y(centerBoxView)+GET_LAYOUT_HEIGHT(centerBoxView)+GAP_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT/4+20)];
//    bottomBoxView.backgroundColor = [UIColor yellowColor];
    UIButton *bindDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(bottomBoxView), (GET_LAYOUT_HEIGHT(bottomBoxView)-GAP_HEIGHT)/2)];
    bindDeviceButton.backgroundColor = [UIColor redColor];
    [bindDeviceButton setTitle:@"绑定设备" forState:UIControlStateNormal];
    [bottomBoxView addSubview:bindDeviceButton];
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(bindDeviceButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(bottomBoxView), (GET_LAYOUT_HEIGHT(bottomBoxView)-GAP_HEIGHT)/2)];
    settingButton.backgroundColor = [UIColor blueColor];
    [settingButton setTitle:NSLocalizedString(@"settingNavigationItemTitle", nil) forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomBoxView addSubview:settingButton];
    [self.view addSubview:bottomBoxView];
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
        [viewController isKindOfClass: NSClassFromString(@"CAMImagePickerCameraViewController")] ){
        isHidden = YES;
    }
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}



#pragma mark - Button Action


- (void)clickTakePhotoButton {
    UploadPhotoController *uploadPhotoController = [[UploadPhotoController alloc] init];
    [self.navigationController pushViewController:uploadPhotoController animated:YES];
    return;
    
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
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ){
//        [self.activityIndicator startAnimating];
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            pickerController.allowsEditing = YES;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持图库");
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
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
////        image = [self fixOrientation:image];
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
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
//    [self.activityIndicator stopAnimating];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell.contentView addSubview:self.photoButton];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.activityIndicator stopAnimating];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
