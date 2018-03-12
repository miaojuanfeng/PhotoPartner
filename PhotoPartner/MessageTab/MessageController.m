//
//  MessageController.m
//  PhotoPartner
//
//  Created by USER on 7/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "MessageController.h"
#import <AFNetworking/AFNetworking.h>

@interface MessageController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
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
    
    
//    NSString *urlString = @"https://well.bsimb.cn/user/user_device?user_id=26";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //block 参数的解释
//        //response 响应头的信息
//        //data 我们所需要的真是的数据
//        //connectionError 链接服务器的错误信息
//        NSLog(@"请求到数据了");
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
//                                                            options:NSJSONReadingAllowFragments error:NULL];
//        NSLog(@"%@", dic);
//    }];
    
    NSString *urlString = @"https://well.bsimb.cn/weather/city_name?city_name=shenzhen";
    NSURL *url = [NSURL URLWithString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSLog(@"results: %@", responseObject);
        NSLog(@"Data results =======================================================================================>:");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"results: %@", error);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"新消息";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
