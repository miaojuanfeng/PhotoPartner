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
    
//    self.messageList = [[NSMutableArray alloc] init];
//    for(int i=0;i<10;i++){
//        if( i%3 == 0 ){
//            NSMutableDictionary *t = [[NSMutableDictionary alloc] init];
//            [t setObject:[NSString stringWithFormat:@"%d", i] forKey:@"id"];
//            [t setObject:@"image" forKey:@"type"];
//            [t setObject:@"Just now" forKey:@"time"];
//            [t setObject:@"Send Photo to xxz(asd123123)" forKey:@"title"];
//            [t setObject:@"test desc" forKey:@"desc"];
//            [t setObject:@"uiimage" forKey:@"data"];
//            [self.messageList addObject:t];
//        }else if( i%3 == 1 ){
//            NSMutableDictionary *t = [[NSMutableDictionary alloc] init];
//            [t setObject:[NSString stringWithFormat:@"%d", i] forKey:@"id"];
//            [t setObject:@"video" forKey:@"type"];
//            [t setObject:@"Just now" forKey:@"time"];
//            [t setObject:@"Send Video to xxz(asd123123)" forKey:@"title"];
//            [t setObject:@"test desc" forKey:@"desc"];
//            [t setObject:@"uiimage" forKey:@"data"];
//            [self.messageList addObject:t];
//        }else if( i%3 == 2 ){
//            NSMutableDictionary *t = [[NSMutableDictionary alloc] init];
//            [t setObject:[NSString stringWithFormat:@"%d", i] forKey:@"id"];
//            [t setObject:@"text" forKey:@"type"];
//            [t setObject:@"Just now" forKey:@"time"];
//            [t setObject:@"Send Photo to xxz(asd123123)" forKey:@"title"];
//            [t setObject:@"test desc" forKey:@"desc"];
//            [t setObject:@"uiimage" forKey:@"data"];
//            [self.messageList addObject:t];
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appDelegate.messageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellHeight:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *messageItem = self.appDelegate.messageList[indexPath.row];
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, GET_LAYOUT_WIDTH(self.tableView)-20, [self getCellHeight:indexPath.row]-20)];
//    messageView.backgroundColor = [UIColor redColor];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(messageView), 20)];
    timeLabel.text = [messageItem objectForKey:@"time"];
//    timeLabel.backgroundColor = [UIColor blueColor];
    [messageView addSubview:timeLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(timeLabel)+GET_LAYOUT_HEIGHT(timeLabel), GET_LAYOUT_WIDTH(messageView), 20)];
    titleLabel.text = [messageItem objectForKey:@"title"];
//    titleLabel.backgroundColor = [UIColor grayColor];
    [messageView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(titleLabel)+GET_LAYOUT_HEIGHT(titleLabel), GET_LAYOUT_WIDTH(messageView), 20)];
    descLabel.text = [messageItem objectForKey:@"desc"];
//    descLabel.backgroundColor = [UIColor orangeColor];
    [messageView addSubview:descLabel];
    
    if( [[[self.appDelegate.messageList objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"image"] ||
        [[[self.appDelegate.messageList objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"video"] ){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(descLabel)+GET_LAYOUT_HEIGHT(descLabel), 200, 150)];
        imageView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64Encoding:[[self.appDelegate.messageList objectAtIndex:indexPath.row] objectForKey:@"data"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [messageView addSubview:imageView];
        
        NSLog(@"%f", GET_LAYOUT_HEIGHT(timeLabel)+GET_LAYOUT_HEIGHT(titleLabel)+GET_LAYOUT_HEIGHT(descLabel)+GET_LAYOUT_HEIGHT(imageView));
    }
    
    NSLog(@"%f", GET_LAYOUT_HEIGHT(timeLabel)+GET_LAYOUT_HEIGHT(titleLabel)+GET_LAYOUT_HEIGHT(descLabel));
    
    [cell.contentView addSubview:messageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)getCellHeight:(long)index {
    if( [[[self.appDelegate.messageList objectAtIndex:index] objectForKey:@"type"] isEqualToString:@"image"] ){
        return IMAGE_CELL_HEIGHT;
    }else if( [[[self.appDelegate.messageList objectAtIndex:index] objectForKey:@"type"] isEqualToString:@"video"] ){
        return VIDEO_CELL_HEIGHT;
    }else{
        return TEXT_CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
