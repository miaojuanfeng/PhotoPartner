//
//  MessageController.m
//  PhotoPartner
//
//  Created by USER on 7/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "MessageController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>

@interface MessageController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;

@property AppDelegate *appDelegate;

@property NSMutableArray *messageList;
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.navigationItem.title = NSLocalizedString(@"messageNavigationItemTitle", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.messageList = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++){
        NSMutableDictionary *t = [[NSMutableDictionary alloc] init];
        [t setObject:[NSString stringWithFormat:@"%d", i] forKey:@"id"];
        [t setObject:@"image" forKey:@"type"];
        [t setObject:@"Just now" forKey:@"time"];
        [t setObject:@"Send Photo to xxz(asd123123)" forKey:@"title"];
        [t setObject:@"test desc" forKey:@"desc"];
        [t setObject:@"uiimage" forKey:@"data"];
        [self.messageList addObject:t];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.text = @"新消息";
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, GET_LAYOUT_WIDTH(self.tableView)-20, GET_LAYOUT_HEIGHT(cell))];
    messageView.backgroundColor = [UIColor redColor];
    
    [cell.contentView addSubview:messageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    
    
    NSLog(@"sadasdasdasd");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
