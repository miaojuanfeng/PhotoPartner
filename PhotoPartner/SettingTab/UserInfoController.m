//
//  UserInfoController.m
//  PhotoPartner
//
//  Created by USER on 23/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "UserInfoController.h"
#import <AFNetworking/AFNetworking.h>

@interface UserInfoController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;

@property UITextField *userNameField;
@property UITextField *userAccountField;

@property AppDelegate *appDelegate;
@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"userInfoNavigationItemTitle", nil);
    
    UIBarButtonItem *userSaveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"saveButton", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickUserSaveButton)];
    self.navigationItem.rightBarButtonItem = userSaveButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if( indexPath.row == 0 ){
        self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, GET_LAYOUT_WIDTH(self.tableView)-30, 44)];
        self.userNameField.text = [self.appDelegate.userInfo objectForKey:@"user_nickname"];
        self.userNameField.backgroundColor = [UIColor whiteColor];
        [self setTextFieldLeftPadding:self.userNameField forWidth:85 forText:NSLocalizedString(@"userInfoUserName", nil)];
        self.userNameField.placeholder = NSLocalizedString(@"userInfoUserNameTextFiledTitle", nil);
        self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [cell.contentView addSubview:self.userNameField];
    }else if( indexPath.row == 1 ){
        self.userAccountField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, GET_LAYOUT_WIDTH(self.tableView)-30, 44)];
        self.userAccountField.backgroundColor = [UIColor whiteColor];
        [self setTextFieldLeftPadding:self.userAccountField forWidth:85 forText:NSLocalizedString(@"userInfoUserAccount", nil)];
        self.userAccountField.text = [[self.appDelegate.userInfo objectForKey:@"user_account"] stringValue];
        self.userAccountField.enabled = NO;
        
        [cell.contentView addSubview:self.userAccountField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth forText:(NSString *)text {
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:frame];
    leftLabel.text = text;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftLabel;
}

- (void)clickUserSaveButton {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    NSDictionary *parameters=@{@"user_id":[self.appDelegate.userInfo objectForKey:@"user_id"], @"user_nickname": self.userNameField.text};
    HUD_WAITING_SHOW(NSLocalizedString(@"hudLoading", nil));
    [manager POST:BASE_URL(@"user/update_profile") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
        int status = [[dic objectForKey:@"status"] intValue];
        
        HUD_WAITING_HIDE;
        if( status == 200 ){
//            NSDictionary *data = [dic objectForKey:@"data"];
//            NSString *device_id = [data objectForKey:@"device_id"];
//            
//            NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
//            [device setObject:device_id forKey:@"device_id"];
//            [device setObject:self.deviceTokenField.text forKey:@"device_token"];
//            [device setObject:self.deviceNameField.text forKey:@"device_name"];
//            [self.appDelegate.deviceList addObject:device];
//            
//            NSLog(@"%@", self.appDelegate.deviceList);
//            [self.appDelegate addDeviceList:device];

            [self.appDelegate.userInfo setObject:self.userNameField.text forKey:@"user_nickname"];
            
            HUD_TOAST_SHOW(NSLocalizedString(@"saveSuccess", nil));
        }else{
            HUD_TOAST_SHOW(NSLocalizedString(@"saveFailed", nil));
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        
        HUD_WAITING_HIDE;
        HUD_TOAST_SHOW(NSLocalizedString(@"saveFailed", nil));
    }];
}

@end
