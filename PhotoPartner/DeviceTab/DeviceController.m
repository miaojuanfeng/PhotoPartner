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

@interface DeviceController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
@property AppDelegate *appDelegate;
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
    
    [cell.contentView addSubview:renameButton];
    
    UIButton *unbindButton = [[UIButton alloc] initWithFrame:CGRectMake(GET_LAYOUT_OFFSET_X(renameButton)+GET_LAYOUT_WIDTH(renameButton)+5, labelMarginTop, cellWidth*0.22-5, 44)];
    [unbindButton setTitle:NSLocalizedString(@"deviceListUnbind", nil) forState:UIControlStateNormal];
    unbindButton.backgroundColor = RGBA_COLOR(27, 162, 230, 1);
    unbindButton.layer.cornerRadius = 10;
    unbindButton.layer.masksToBounds = YES;
    
    [cell.contentView addSubview:unbindButton];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
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

@end
