//
//  AddDeviceController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "AddDeviceController.h"

@interface AddDeviceController ()
@property AppDelegate *appDelegate;
@property UITextField *deviceNameField;
@property UITextField *deviceTokenField;
@end

@implementation AddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"deviceAddNavigationItemTitle", nil);
    
    UIBarButtonItem *deviceAddButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickDeviceAddButtonButton)];
    self.navigationItem.rightBarButtonItem = deviceAddButton;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *deviceView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH, MARGIN_TOP+GAP_HEIGHT, VIEW_WIDTH-2*GAP_WIDTH, VIEW_HEIGHT)];
    
    UILabel *deviceName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceName.text = NSLocalizedString(@"deviceAddDeviceName", nil);
    [deviceView addSubview:deviceName];
    
    self.deviceNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceName)+GET_LAYOUT_HEIGHT(deviceName), GET_LAYOUT_WIDTH(deviceView), 34)];
    self.deviceNameField.layer.borderColor = BORDER_COLOR;
    self.deviceNameField.layer.borderWidth = BORDER_WIDTH;
    [deviceView addSubview:self.deviceNameField];
    
    UILabel *deviceNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(self.deviceNameField)+GET_LAYOUT_HEIGHT(self.deviceNameField), GET_LAYOUT_WIDTH(deviceView), 34)];
    deviceNumber.text = NSLocalizedString(@"deviceAddDeviceNumber", nil);
    [deviceView addSubview:deviceNumber];
    
    self.deviceTokenField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(deviceNumber)+GET_LAYOUT_HEIGHT(deviceNumber), GET_LAYOUT_WIDTH(deviceView), 34)];
    self.deviceTokenField.layer.borderColor = BORDER_COLOR;
    self.deviceTokenField.layer.borderWidth = BORDER_WIDTH;
    [deviceView addSubview:self.deviceTokenField];
    
    [self.view addSubview:deviceView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickDeviceAddButtonButton {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    NSDictionary *parameters=@{@"user_id":@"45",@"device_token":self.deviceTokenField.text,@"device_name":self.deviceNameField.text};
    [manager POST:BASE_URL(@"device/bind") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
        int status = [[dic objectForKey:@"status"] intValue];
        
        if( status == 200 ){
            NSDictionary *data = [dic objectForKey:@"data"];
            NSString *device_id = [data objectForKey:@"device_id"];
            
            NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
            [device setObject:device_id forKey:@"device_id"];
            [device setObject:self.deviceTokenField.text forKey:@"device_token"];
            [device setObject:self.deviceNameField.text forKey:@"device_name"];
            [self.appDelegate.deviceList addObject:device];
            
            NSLog(@"%@", self.appDelegate.deviceList);
            [self.appDelegate saveDeviceList:device];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
    
}

@end
