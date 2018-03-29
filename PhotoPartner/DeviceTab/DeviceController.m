//
//  DeviceController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "DeviceController.h"
#import "AddDeviceController.h"
#import <AFNetworking/AFNetworking.h>

@interface DeviceController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
@property AppDelegate *appDelegate;
@property UILabel *emptyLabel;
@end

@implementation DeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"deviceListNavigationItemTitle", nil);
    
    UIBarButtonItem *deviceAddButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickDeviceAddButton)];
    self.navigationItem.rightBarButtonItem = deviceAddButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appDelegate.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int labelMarginTop = 5;
    if( indexPath.row == 0 ){
        tableView.rowHeight = 59;
        labelMarginTop = 10;
    }else if( indexPath.row == self.appDelegate.deviceList.count - 1 ){
        tableView.rowHeight = 59;
    }else{
        tableView.rowHeight = 54;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSMutableDictionary *deviceItem = self.appDelegate.deviceList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int cellWidth = GET_LAYOUT_WIDTH(tableView) - 20;
    
    UIView *deviceLabelView = [[UIView alloc] initWithFrame:CGRectMake(10, labelMarginTop, cellWidth*0.56, 44)];
    deviceLabelView.backgroundColor = RGBA_COLOR(27, 162, 230, 1);
    deviceLabelView.layer.cornerRadius = 10;
    deviceLabelView.layer.masksToBounds = YES;
    
    UILabel *deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, GET_LAYOUT_WIDTH(deviceLabelView)-20, GET_LAYOUT_HEIGHT(deviceLabelView))];
    deviceLabel.text = [NSString stringWithFormat:@"%@(%@)", [deviceItem objectForKey:@"device_name"], [deviceItem objectForKey:@"device_token"]];
    deviceLabel.textColor = [UIColor whiteColor];
    [deviceLabelView addSubview:deviceLabel];
    
    [cell.contentView addSubview:deviceLabelView];
    
    UIButton *renameButton = [[UIButton alloc] initWithFrame:CGRectMake(GET_LAYOUT_OFFSET_X(deviceLabelView)+GET_LAYOUT_WIDTH(deviceLabelView)+5, labelMarginTop, cellWidth*0.22-5, 44)];
    [renameButton setTitle:NSLocalizedString(@"deviceListRename", nil) forState:UIControlStateNormal];
    renameButton.backgroundColor = RGBA_COLOR(27, 162, 230, 1);
    renameButton.layer.cornerRadius = 10;
    renameButton.layer.masksToBounds = YES;
    renameButton.tag = [[deviceItem objectForKey:@"device_id"] intValue];
    [renameButton addTarget:self action:@selector(clickRenameButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:renameButton];
    
    UIButton *unbindButton = [[UIButton alloc] initWithFrame:CGRectMake(GET_LAYOUT_OFFSET_X(renameButton)+GET_LAYOUT_WIDTH(renameButton)+5, labelMarginTop, cellWidth*0.22-5, 44)];
    [unbindButton setTitle:NSLocalizedString(@"deviceListUnbind", nil) forState:UIControlStateNormal];
    unbindButton.backgroundColor = RGBA_COLOR(27, 162, 230, 1);
    unbindButton.layer.cornerRadius = 10;
    unbindButton.layer.masksToBounds = YES;
    unbindButton.tag = [[deviceItem objectForKey:@"device_id"] intValue];
    [unbindButton addTarget:self action:@selector(clickUnbindButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:unbindButton];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [self isEmptyDeviceList];
}

- (void)isEmptyDeviceList{
    NSLog(@"self.appDelegate.deviceList: %@", self.appDelegate.deviceList);
    if( self.appDelegate.deviceList.count == 0 ){
        self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 95)];
        self.emptyLabel.numberOfLines = 0;
        self.emptyLabel.font =  [UIFont fontWithName:@"AppleGothic" size:18.0];
        self.emptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.emptyLabel.textColor = [UIColor colorWithCGColor:BORDER_COLOR];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.emptyLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"deviceListEmpty", nil) attributes:attributes];
        
        [self.tableView addSubview:self.emptyLabel];
    }else{
        [self.emptyLabel removeFromSuperview];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickDeviceAddButton {
    AddDeviceController *addDeviceController = [[AddDeviceController alloc] init];
    [self.navigationController pushViewController:addDeviceController animated:YES];
}

- (void)clickRenameButton:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"deviceListRenameTextFieldTitle", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"deviceListRenameTextFieldTitle", nil);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmOK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *deviceName = alertController.textFields.firstObject.text;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30.0f;
        NSDictionary *parameters=@{
                                   @"user_id":[self.appDelegate.userInfo objectForKey:@"user_id"],
                                   @"device_id":[NSString stringWithFormat:@"%ld", btn.tag],
                                   @"device_name":deviceName
                                   };
        HUD_WAITING_SHOW(NSLocalizedString(@"hudLoading", nil));
        [manager POST:BASE_URL(@"device/rename") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            
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
                for (int i=0;i<self.appDelegate.deviceList.count;i++) {
                    NSMutableDictionary *device = [self.appDelegate.deviceList objectAtIndex:i];
                    if( [[device objectForKey:@"device_id"] intValue] == btn.tag ){
                        [device setObject:deviceName forKey:@"device_name"];
                        [self.appDelegate.deviceList replaceObjectAtIndex:i withObject:device];
                        break;
                    }
                }
                [self.appDelegate saveDeviceList];
                [self.tableView reloadData];
                HUD_TOAST_SHOW(NSLocalizedString(@"deviceListRenameSuccess", nil));
            }else{
                HUD_TOAST_SHOW(NSLocalizedString(@"deviceListRenameFailed", nil));
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败.%@",error);
            NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
            
            HUD_WAITING_HIDE;
            HUD_TOAST_SHOW(NSLocalizedString(@"deviceListRenameFailed", nil));
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickUnbindButton:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"deviceListUnbindConfirmTitle", nil)
                                                                             message:NSLocalizedString(@"deviceListUnbindConfirmSubtitle", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmOK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30.0f;
        NSDictionary *parameters=@{
                                   @"user_id":[self.appDelegate.userInfo objectForKey:@"user_id"],
                                   @"device_id":[NSString stringWithFormat:@"%ld", btn.tag],
                                   @"status":@"unbind"
                                   };
        HUD_WAITING_SHOW(NSLocalizedString(@"hudLoading", nil));
        [manager POST:BASE_URL(@"device/status") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            
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
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *time = [dateFormatter stringFromDate:date];
                long device_id = btn.tag;
                NSString *deviceName = @"";
                for(int k=0;k<self.appDelegate.deviceList.count;k++){
                                        NSLog(@"%@", [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_id"] );
                                        NSLog(@"%ld", device_id);
                                        NSLog(@"%d", [[[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_id"] longValue] == device_id);
                    if( [[[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_id"] longValue] == device_id ){
                        NSString *device_name = [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_name"];
                        NSString *device_token = [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_token"];
                        deviceName = [NSString stringWithFormat:@"%@(%@)", device_name, device_token];
                        break;
                    }
                }
                NSString *title = [NSString stringWithFormat:@"Unbind device %@", deviceName];
                NSString *desc = @"";
                [self.appDelegate addMessageList:@"text" withTime:time withTitle:title withDesc:desc withData:nil];
                
                
                for (NSDictionary *device in self.appDelegate.deviceList) {
                    if( [[device objectForKey:@"device_id"] intValue] == btn.tag ){
                        [self.appDelegate.deviceList removeObject:device];
                        break;
                    }
                }
                [self.appDelegate saveDeviceList];
                [self isEmptyDeviceList];
                [self.tableView reloadData];
                
                HUD_TOAST_SHOW(NSLocalizedString(@"deviceListUnbindSuccess", nil));
            }else{
                HUD_TOAST_SHOW(NSLocalizedString(@"deviceListUnbindFailed", nil));
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败.%@",error);
            NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
            
            HUD_WAITING_HIDE;
            HUD_TOAST_SHOW(NSLocalizedString(@"deviceListUnbindFailed", nil));
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
