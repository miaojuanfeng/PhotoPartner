//
//  AddDeviceController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AddDeviceController.h"

@interface AddDeviceController ()

@end

@implementation AddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"deviceAddNavigationItemTitle", nil);
    
    UIBarButtonItem *deviceAddButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickDeviceAddButtonButton)];
    self.navigationItem.rightBarButtonItem = deviceAddButton;
    
    UIView *deviceView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, MARGIN_TOP+GAP_HEIGHT, VIEW_WIDTH-2*GAP_WIDTH, VIEW_HEIGHT)];
    
    UILabel *deviceName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceName.text = NSLocalizedString(@"deviceAddDeviceName", nil);
    [deviceView addSubview:deviceName];
    
    UITextField *deviceNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceName)+GET_LAYOUT_HEIGHT(deviceName), GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceNameField.layer.borderColor = BORDER_COLOR;
    deviceNameField.layer.borderWidth = BORDER_WIDTH;
    [deviceView addSubview:deviceNameField];
    
    UILabel *deviceNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceNameField)+GET_LAYOUT_HEIGHT(deviceNameField), GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceNumber.text = NSLocalizedString(@"deviceAddDeviceNumber", nil);
    [deviceView addSubview:deviceNumber];
    
    UITextField *deviceNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceNumber)+GET_LAYOUT_HEIGHT(deviceNumber), GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceNumberField.layer.borderColor = BORDER_COLOR;
    deviceNumberField.layer.borderWidth = BORDER_WIDTH;
    [deviceView addSubview:deviceNumberField];
    
    [self.view addSubview:deviceView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickDeviceAddButtonButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
