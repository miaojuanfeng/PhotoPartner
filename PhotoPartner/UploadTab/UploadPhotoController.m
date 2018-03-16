//
//  UploadPhotoController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <TZImagePickerController.h>
#import "MacroDefine.h"
#import "AppDelegate.h"
#import "UploadPhotoController.h"

#define IMAGE_PER_ROW 5
#define IMAGE_VIEW_SIZE (GET_LAYOUT_WIDTH(self.view)-GAP_WIDTH*(IMAGE_PER_ROW+1))/IMAGE_PER_ROW

@interface UploadPhotoController () <UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate>
@property UITableView *tableView;
@property TZImagePickerController *imagePickerVc;

@property AppDelegate *appDelegate;

@property UITextView *textView;
@property UIView *mediaView;
@property UIButton *addImageButton;

@property UIProgressView *progressView;
@end

@implementation UploadPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    
    self.navigationItem.title = NSLocalizedString(@"uploadPhotoNavigationItemTitle", nil);
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, GET_LAYOUT_WIDTH(self.view), 1)];
//    [self.navigationController.navigationBar addSubview:self.progressView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [self.view addSubview:self.tableView];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


    self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    self.imagePickerVc.allowPickingVideo = NO;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), 100)];
    if( self.appDelegate.isSending ){
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadSendingRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
        submitButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = submitButton;
        long imageRowCount = self.appDelegate.photos.count/IMAGE_PER_ROW+1;
        self.mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), IMAGE_VIEW_SIZE*imageRowCount+(imageRowCount-1)*GAP_HEIGHT+2*GAP_HEIGHT)];
        self.textView.text = self.appDelegate.fileDesc[self.appDelegate.focusImageIndex];
    }else{
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadSendRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
        self.navigationItem.rightBarButtonItem = submitButton;
        self.mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), IMAGE_VIEW_SIZE+2*GAP_HEIGHT)];
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:)name:@"tongzhi" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"推送设备";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if( section == 0 ){
        return 2;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return CGFLOAT_MIN;
    }else{
//        return tableView.sectionHeaderHeight;
        return 12;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UploadMediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.frame = CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.tableView), tableView.rowHeight);
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.textView);
            NSLog(@"%f",GET_LAYOUT_HEIGHT(self.textView));
//            self.textView.backgroundColor = [UIColor redColor];
            self.textView.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
            
            [cell.contentView addSubview:self.textView];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if( indexPath.row == 1 ){
//            mediaView.backgroundColor = [UIColor blueColor];
//            int imagePerRow = 5;
//            int imageTotal = 10;
//            float imageViewSize = (GET_LAYOUT_WIDTH(mediaView)-GAP_WIDTH*(imagePerRow+1))/imagePerRow;
//            float x = GAP_WIDTH;
//            float y = GAP_HEIGHT;
//            for(int i=0;i<imageTotal;i++){
//                if( i%imagePerRow == 0 ){
//                    x = GAP_WIDTH;
//                }else{
//                    x += imageViewSize + GAP_HEIGHT;
//                }
//                if( i > 0 && i%imagePerRow == 0 ){
//                    y += imageViewSize + GAP_HEIGHT;
//                    mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(mediaView), 0, GET_LAYOUT_WIDTH(mediaView), y+imageViewSize+GAP_HEIGHT);
//                }
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
//        //        imageView.backgroundColor = [UIColor orangeColor];
//                imageView.image = [UIImage imageNamed:@"image"];
//                [mediaView addSubview:imageView];
//            }
            NSLog(@"mediaView HEight: %f", GET_LAYOUT_HEIGHT(self.mediaView));
//            CGRect rect = cell.frame;
//            rect.size.height = [self getMediaView:cell];
//            cell.frame = rect;
//            NSLog(@"%f", GET_LAYOUT_HEIGHT(cell));
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.mediaView);
            [self getMediaView:cell];
//            cell.backgroundColor = [UIColor blueColor];
        }
    }else{
        self.tableView.rowHeight = 44;
        cell.textLabel.text = @"设备编号（axz1122334）";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)getMediaView:(UITableViewCell *)cell {
//    mediaView.backgroundColor = [UIColor blueColor];
    if( self.appDelegate.photos.count == 0 ){
        self.mediaView.frame = CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), IMAGE_VIEW_SIZE+2*GAP_HEIGHT);
    }
    long imageTotal = self.appDelegate.photos.count;
    float imageViewSize = IMAGE_VIEW_SIZE;
    float x = GAP_WIDTH;
    float y = GAP_HEIGHT;
    for(int i=0;i<imageTotal;i++){
        if( i%IMAGE_PER_ROW == 0 ){
            x = GAP_WIDTH;
        }else{
            x += imageViewSize + GAP_HEIGHT;
        }
        if( i > 0 && i%IMAGE_PER_ROW == 0 ){
            y += imageViewSize + GAP_HEIGHT;
            self.mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), 0, GET_LAYOUT_WIDTH(self.mediaView), y+imageViewSize+GAP_HEIGHT);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
        //        imageView.backgroundColor = [UIColor orangeColor];
        imageView.image = self.appDelegate.photos[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imageView setTag:i];
        [imageView addGestureRecognizer:singleTap];
        [self.mediaView addSubview:imageView];
    }
    
    if( imageTotal%IMAGE_PER_ROW == 0 ){
        x = GAP_WIDTH;
    }else{
        x += imageViewSize + GAP_HEIGHT;
    }
    if( imageTotal > 0 && imageTotal%IMAGE_PER_ROW == 0 ){
        y += imageViewSize + GAP_HEIGHT;
        self.mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), 0, GET_LAYOUT_WIDTH(self.mediaView), y+imageViewSize+GAP_HEIGHT);
    }
    /*
     *  移除旧的CGRect可点击区域
     */
    [self.addImageButton removeFromSuperview];
    self.addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
    [self.addImageButton setImage:[UIImage imageNamed:@"iv_upload"] forState:UIControlStateNormal];
    [self.addImageButton addTarget:self action:@selector(clickAddMediaButton) forControlEvents:UIControlEventTouchUpInside];
    self.addImageButton.layer.borderColor = BORDER_COLOR;
    self.addImageButton.layer.borderWidth = BORDER_WIDTH;
    [self.mediaView addSubview:self.addImageButton];
    
    [cell.contentView addSubview:self.mediaView];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.rowHeight = GET_LAYOUT_HEIGHT(mediaView);
//    cell.frame = CGRectMake(GET_LAYOUT_OFFSET_X(cell), GET_LAYOUT_OFFSET_Y(cell), GET_LAYOUT_WIDTH(cell), GET_LAYOUT_HEIGHT(mediaView));
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"self.tableView.rowHeight: %f", GET_LAYOUT_HEIGHT(cell));
    NSLog(@"mediaView Height: %f", GET_LAYOUT_HEIGHT(self.mediaView));
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.section > 0 ){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.appDelegate.focusImageIndex = self.appDelegate.fileDesc.count;
    for (int i=0; i<photos.count; i++) {
        [self.appDelegate.photos addObject:photos[i]];
        [self.appDelegate.fileDesc addObject:@""];
    }
    NSLog(@"self.photos: %@", self.appDelegate.photos);
    self.textView.text = [self.appDelegate.fileDesc objectAtIndex:self.appDelegate.focusImageIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self getMediaView:cell];
    [self.tableView reloadData];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    NSLog(@"%@", coverImage);
//}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"Cancel");
}


/*
 *  要让AFHTTPSessionManager支持上传表单数组，需要修改AFNetworking/Serialization/AFURLRequestSerialization.m
 *  将
 *  [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
 *  修改为
 *  [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@", key], nestedValue)];
 */

- (void)clickSubmitButton {
    [self.view endEditing:YES];
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*
     *  返回json格式数据时，如果没有下面代码，会提示上传失败，实际上已经成功。
     *  加上下面这句才会提示成功
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    //发送post请求上传路径
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    NSLog(@"%ld", self.appDelegate.photos.count);
    NSMutableArray<NSData *> *file = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.appDelegate.photos.count; i++) {
        [self.appDelegate.deviceId addObject:@1];
//        [self.fileDesc addObject:@2];
        [file addObject:UIImagePNGRepresentation(self.appDelegate.photos[i])];
    }
    NSDictionary *parameters=@{@"user_id":@"1",@"device_id":[self.appDelegate.deviceId copy],@"file_desc":[self.appDelegate.fileDesc copy]};
    [manager POST:BASE_URL(@"upload/image") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        /*
        *   使用formData拼接数据
        *   方法一:
        *   第一个参数:二进制数据 要上传的文件参数
        *   第二个参数:服务器规定的
        *   第三个参数:文件上传到服务器以什么名称保存
        */
        for (int i=0; i< file.count; i++) {
            NSString *fileExt = [self typeForImageData:file[i]];
            if( fileExt == nil ){
                fileExt = @"jpeg";
            }
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *fileName = [NSString stringWithFormat:@"IMG_%@_%d", [dateFormatter stringFromDate:date], arc4random() % 50001 + 100000];
            [formData appendPartWithFileData:file[i] name:@"file" fileName:[NSString stringWithFormat:@"%@.%@", fileName, fileExt] mimeType:[NSString stringWithFormat:@"image/%@", fileExt]];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"uploadSendingRightBarButtonItemTitle", nil);
        self.progressView.progress = 0.0;
        [self.navigationController.navigationBar addSubview:self.progressView];
        self.appDelegate.isSending = true;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            self.progressView.progress = progress;
            self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d%%", (int)floor(progress*100)];
        });
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);

//        [self.appDelegate clearProperty];
//        NSArray *views = [self.mediaView subviews];
//        for(UIView *view in views){
//            [view removeFromSuperview];
//        }
//        self.textView.text = @"";
//        [self.tableView reloadData];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        self.navigationItem.rightBarButtonItem.title = @"发送";
//        [self.progressView removeFromSuperview];
//        self.appDelegate.isSending = false;
        
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);

        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.title = @"发送";
        [self.progressView removeFromSuperview];
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

//- (AFHTTPSessionManager *)sharedManager {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //最大请求并发任务数
//    manager.operationQueue.maxConcurrentOperationCount = 5;
//
//    // 请求格式
//    // AFHTTPRequestSerializer            二进制格式
//    // AFJSONRequestSerializer            JSON
//    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//
//    // 超时时间
//    manager.requestSerializer.timeoutInterval = 30.0f;
//    // 设置请求头
//    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    // 设置接收的Content-Type
//    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    // 返回格式
//    // AFHTTPResponseSerializer           二进制格式
//    // AFJSONResponseSerializer           JSON
//    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
//    // AFXMLDocumentResponseSerializer (Mac OS X)
//    // AFPropertyListResponseSerializer   PList
//    // AFImageResponseSerializer          Image
//    // AFCompoundResponseSerializer       组合
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
////    //设置返回C的ontent-type
////    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    return manager;
//}

- (void)clickAddMediaButton {
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}

- (void)clickImageView:(UIGestureRecognizer *) sender{
    [self setTextViewToFileDesc];
    self.appDelegate.focusImageIndex = sender.view.tag;
    self.textView.text = [self.appDelegate.fileDesc objectAtIndex:sender.view.tag];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setTextViewToFileDesc];
    NSLog(@"%@", self.appDelegate.fileDesc);
}

- (void)setTextViewToFileDesc {
    if( self.appDelegate.focusImageIndex > -1 ){
        NSLog(@"sds");
        [self.appDelegate.fileDesc replaceObjectAtIndex:self.appDelegate.focusImageIndex withObject:self.textView.text];
    }
}

- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

- (void)tongzhi:(NSNotification *)text{
//    NSLog(@"%@",text);
    
    [self.appDelegate clearProperty];
    NSArray *views = [self.mediaView subviews];
    for(UIView *view in views){
        [view removeFromSuperview];
    }
    self.textView.text = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self getMediaView:cell];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"uploadSendRightBarButtonItemTitle", nil);
    [self.progressView removeFromSuperview];
    self.appDelegate.isSending = false;
    
    NSLog(@"－－－－－接收到通知------");
}

@end

