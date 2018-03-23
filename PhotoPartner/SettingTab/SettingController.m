//
//  SettingController.m
//  PhotoPartner
//
//  Created by USER on 7/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "SettingController.h"
#import "UserInfoController.h"

@interface SettingController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"settingNavigationItemTitle", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch( section ){
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch( section ){
        case 0:
            return @"个人设置";
            break;
        case 1:
            return @"系统设置";
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if( indexPath.section == 0 ){
        switch( indexPath.row ){
            case 0:
                cell.textLabel.text = @"个人信息";
                break;
        }
    }else if( indexPath.section == 1 ){
        switch( indexPath.row ){
            case 0:
                cell.textLabel.text = @"清空全部消息记录";
                break;
            case 1:
                cell.textLabel.text = @"版本更新";
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserInfoController *userInfoController;
    
    switch (indexPath.row) {
        case 0:
            userInfoController = [[UserInfoController alloc] init];
            [self.navigationController pushViewController:userInfoController animated:YES];
            break;
            
        case 1:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

