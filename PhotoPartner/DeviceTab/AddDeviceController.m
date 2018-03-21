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
    self.view.backgroundColor = RGBA_COLOR(239, 239, 239, 1);
    self.navigationItem.title = NSLocalizedString(@"deviceAddNavigationItemTitle", nil);
    
//    UIBarButtonItem *deviceAddButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickDeviceAddButtonButton)];
//    self.navigationItem.rightBarButtonItem = deviceAddButton;
    
    UIView *deviceView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH*2, MARGIN_TOP+GAP_HEIGHT*2, VIEW_WIDTH-4*GAP_WIDTH, VIEW_HEIGHT)];
    
    UITextField *deviceNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(deviceView), 44)];
    deviceNameField.backgroundColor = [UIColor whiteColor];
    [self setTextFieldLeftPadding:deviceNameField forWidth:10];
    deviceNameField.layer.cornerRadius = 5;
    deviceNameField.layer.masksToBounds = YES;
    deviceNameField.placeholder = NSLocalizedString(@"deviceAddDeviceName", nil);
    deviceNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [deviceView addSubview:deviceNameField];
    
    UITextField *deviceNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceNameField)+GET_LAYOUT_HEIGHT(deviceNameField)+10, GET_LAYOUT_WIDTH(deviceView), 44)];
    deviceNumberField.backgroundColor = [UIColor whiteColor];
    [self setTextFieldLeftPadding:deviceNumberField forWidth:10];
    deviceNumberField.layer.cornerRadius = 5;
    deviceNumberField.layer.masksToBounds = YES;
    deviceNumberField.placeholder = NSLocalizedString(@"deviceAddDeviceNumber", nil);
    deviceNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [deviceView addSubview:deviceNumberField];
    
    UIButton *deviceAddButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceNumberField)+GET_LAYOUT_HEIGHT(deviceNumberField)+10, GET_LAYOUT_WIDTH(deviceView), 44)];
    deviceAddButton.backgroundColor = RGBA_COLOR(27, 163, 232, 1);
    deviceAddButton.layer.cornerRadius = 5;
    deviceAddButton.layer.masksToBounds = YES;
    [deviceAddButton setTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) forState:UIControlStateNormal];
    [deviceAddButton addTarget:self action:@selector(clickDeviceAddButtonButton) forControlEvents:UIControlEventTouchUpInside];
    [deviceView addSubview:deviceAddButton];
    
    [self.view addSubview:deviceView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth {
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (void)clickDeviceAddButtonButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
