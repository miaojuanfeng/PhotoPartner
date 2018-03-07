//
//  ViewController.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "HomeController.h"
#import "MessageController.h"
#import "SettingController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
//    self.navigationItem.title = @"照片伴侣";
    
    VIEW_WIDTH = VIEW_WIDTH - GAP_WIDTH * 2;
    VIEW_HEIGHT = VIEW_HEIGHT - GAP_HEIGHT * 3;
    
    UIView *topBoxView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT/4-20)];
    UIButton *takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(topBoxView), GET_LAYOUT_HEIGHT(topBoxView))];
    [takePhotoButton setTitle:@"拍照片" forState:UIControlStateNormal];
    takePhotoButton.backgroundColor = [UIColor blueColor];
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
    [centerRightBoxView addSubview:photoLibButton];
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_HEIGHT(photoLibButton)+GAP_HEIGHT, GET_LAYOUT_WIDTH(centerRightBoxView), (GET_LAYOUT_HEIGHT(centerRightBoxView)-GAP_HEIGHT)/3*2)];
    messageButton.backgroundColor = [UIColor greenColor];
    [messageButton setTitle:@"消息" forState:UIControlStateNormal];
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
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomBoxView addSubview:settingButton];
    [self.view addSubview:bottomBoxView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)clickMessageButton {
    MessageController *messageController = [[MessageController alloc] init];
    [self.navigationController pushViewController:messageController animated:YES];
}

- (void)clickSettingButton {
    SettingController *settingController = [[SettingController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

@end
